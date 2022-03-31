import { Chart } from "chart.js"

// @types/chart.jsに型宣言がないメタメソッドを使うためのインタフェース
interface MetaChart extends Chart {
  scales: {
    "x-axis-1": {
      getValueForPixel: (x: number) => number | undefined
      getPixelForValue: (x: number) => number
    }
    "y-axis-1": {
      getValueForPixel: (y: number) => number | undefined
      getPixelForValue: (y: number) => number
    }
  }
}

export type GraphP = Chart.Point | null

export type DomValues = { taste: number; aroma: number }

/*
 * HACK:
 *   内部データが0〜6に対してグラフデータが-3〜3のため、
 *   オフセットズレを補正するための数値
 */
const middle = 3

export function fromDom(taste: number, aroma: number): GraphP {
  // taste/aromaはNaNの可能性がある
  return isNaN(taste) || isNaN(aroma)
    ? null
    : { x: taste - middle, y: aroma - middle }
}

export function toDom(p: GraphP): DomValues {
  return p
    ? { taste: p.x + middle, aroma: p.y + middle }
    : { taste: NaN, aroma: NaN }
}

export const graphPZero = { x: 0, y: 0 }

interface InteractiveGraph {
  update(data: GraphP): void
}

export class TasteGraph implements InteractiveGraph {
  public graph: Chart
  private data: GraphP

  /*
   * HACk:
   *   graphは常に0or1点データしか持たないという制約をしている。
   *   そのため、1点データを持つグラフにpopを1回すれば全データが消える。
   */
  private popData(): void {
    this.graph.data.datasets?.forEach((dataset) => {
      dataset.data?.pop()
    })
  }

  private pushData(newData: Chart.Point): void {
    const datasets = this.graph.data.datasets
    if (datasets != null) {
      datasets.forEach((dataset: Chart.ChartDataSets) => {
        const d = dataset.data as Chart.ChartPoint[]
        d.push(newData)
      })
    }
  }

  public update(newData: GraphP): void {
    if (this.data != null) this.popData()
    if (newData != null) this.pushData(newData)
    this.graph.update()
    this.callbackUpdate(toDom(newData))
    this.data = newData
  }

  private getClickedData(event: MouseEvent): GraphP {
    const g = this.graph as MetaChart
    let x = g.scales["x-axis-1"].getValueForPixel(event.offsetX)
    let y = g.scales["y-axis-1"].getValueForPixel(event.offsetY)
    // undefinedチェック
    if (x != null && y != null) {
      x = Math.round(x)
      y = Math.round(y)
      return { x, y }
    } else return null
  }

  private eqGraphP(p1: GraphP, p2: GraphP) {
    if (p1 == null && p2 == null) return true
    else if (p1 == null || p2 == null) return false
    else if (p1.x == p2.x && p1.y == p2.y) return true
    else return false
  }

  // JSに渡すときにthis問題を防ぐため、アロー関数で書いておく
  private onClickUpdate = (event: MouseEvent): void => {
    let data = this.getClickedData(event)
    if (this.data != null && this.eqGraphP(data, this.data)) data = null
    this.update(data)
  }

  private makeChartData(data: GraphP): Chart.ChartData {
    const points = data != null ? [data] : []
    const datasets: Chart.ChartDataSets = {
      data: points,
      // accent color: #b7282e = 183,40,46
      pointBackgroundColor: "rgba(183, 40, 46, 0.9)",
      pointBorderColor: "rgba(183, 40, 46, 1.0)",
    }
    const cd: Chart.ChartData = {
      datasets: [datasets],
    }
    return cd
  }

  private makeChartConfiguration(
    dataset: Chart.ChartData,
    config: {
      pointRadius?: number
      zeroLineWidth?: number
    }
  ): Chart.ChartConfiguration {
    const defaultedConfig = {
      ...{ pointRadius: 10, zeroLineWidth: 7 },
      ...config,
    }
    const margin = 0.2
    const ticks: Chart.TickOptions = {
      display: false,
      max: middle + margin,
      min: -middle - margin,
      maxTicksLimit: 2,
    }
    const dummyGridLines: Chart.GridLineOptions = {
      drawTicks: false,
      drawOnChartArea: false,
    }
    const gridLines: Chart.GridLineOptions = {
      drawTicks: false,
      drawOnChartArea: true,
      zeroLineWidth: defaultedConfig.zeroLineWidth,
    }
    const baseAxe: Chart.ChartXAxe = {
      ticks: ticks,
      gridLines: gridLines,
    }
    const xAxe: Chart.ChartXAxe = {
      ...baseAxe,
      position: "bottom",
      scaleLabel: {
        display: true,
        labelString: "香りが低い",
      },
    }
    const dummyXAxe: Chart.ChartXAxe = {
      ...baseAxe,
      position: "top",
      scaleLabel: {
        display: true,
        labelString: "香りが高い",
      },
    }
    const yAxe: Chart.ChartYAxe = {
      ...baseAxe,
      position: "left",
      scaleLabel: {
        display: true,
        labelString: "味が淡い",
      },
    }
    const dummyYAxe: Chart.ChartYAxe = {
      ...baseAxe,
      gridLines: dummyGridLines, // HACK: X軸（y=0）の二重描きを防ぐ
      position: "right",
      scaleLabel: {
        display: true,
        labelString: "味が濃い",
      },
    }
    const options: Chart.ChartOptions = {
      onClick: this.clickable
        ? this.onClickUpdate
        : (_event) => {
            // do nothing
          },
      legend: { display: false },
      elements: { point: { radius: defaultedConfig.pointRadius } },
      // HACK: ダミーの軸を使って高低両方にラベルをつける
      scales: { xAxes: [xAxe, dummyXAxe], yAxes: [yAxe, dummyYAxe] },
      responsive: true,
      maintainAspectRatio: false,
    }
    // 各4象限を別々に色付けする
    // https://github.com/chartjs/Chart.js/issues/3535
    const backgroundColorPlugin = {
      beforeDraw: function (chart: MetaChart, _: Chart.Easing) {
        const ctx = chart.ctx

        const left = chart.chartArea.left
        const right = chart.chartArea.right
        const top = chart.chartArea.top
        const bottom = chart.chartArea.bottom
        const midX = chart.scales["x-axis-1"].getPixelForValue(0)
        const midY = chart.scales["y-axis-1"].getPixelForValue(0)

        // primary color: #19448e = 25,68,142
        const color1 = "rgba(25, 68, 142, 0.18)"
        const color2 = "rgba(25, 68, 142, 0.09)"
        const color3 = "rgba(25, 68, 142, 0.02)"
        const color4 = color2

        if (ctx != null) {
          // Top right, quadrant 1
          ctx.fillStyle = color1
          ctx.fillRect(midX, top, right - midX, midY - top)
          // Top left, quadrant 2
          ctx.fillStyle = color2
          ctx.fillRect(left, top, midX - left, midY - top)
          // Bottom left, quadrant 3
          ctx.fillStyle = color3
          ctx.fillRect(left, midY, midX - left, bottom - midY)
          // Bottom right, quadrant 4
          ctx.fillStyle = color4
          ctx.fillRect(midX, midY, right - midX, bottom - midY)
        }
      },
    }
    const chartConfig: Chart.ChartConfiguration = {
      type: "scatter",
      data: dataset,
      options: options,
      plugins: [backgroundColorPlugin],
    }
    return chartConfig
  }

  constructor(
    canvas: HTMLCanvasElement,
    taste: number, // NaNがありうる
    aroma: number, // NaNがありうる
    config: { pointRadius?: number; zeroLineWidth?: number },
    private clickable: boolean = false,
    private callbackUpdate: (data: DomValues) => void = (_data) => {
      // do nothing
    }
  ) {
    this.data = isNaN(taste) || isNaN(aroma) ? null : fromDom(taste, aroma)
    const p = this.makeChartData(this.data)
    const chartConfig = this.makeChartConfiguration(p, config)
    this.graph = new Chart(canvas, chartConfig)
  }
}
