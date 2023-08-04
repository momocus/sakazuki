import merge from "ts-deepmerge"
import { Chart, ScatterController, PointElement, LinearScale } from "chart.js"
import type {
  Color,
  ChartOptions,
  ChartConfiguration,
  ChartEvent,
  ScriptableScaleContext,
  ActiveElement,
  BubbleDataPoint,
  Point,
} from "chart.js"
import { getRelativePosition } from "chart.js/helpers"

Chart.register(ScatterController, PointElement, LinearScale)

/**
 * DOMに保存された味・香りの数値
 */
export type DomValues = { taste: string; aroma: string }

/**
 * グラフクリックされた値に対するコールバック関数
 */
export type DomCallback = (d: DomValues) => void

/**
 * TasteGraphのカスタマイズ値
 */
export type TasteGraphConfig = {
  lineWidth?: number
  pointRadius?: number
}

/**
 * 味・香りグラフ
 *
 * chart.jsの散布図で表示される。
 * 表示するだけのモードと、グラフクリックで入力できるモードがある。
 */
export class TasteGraph extends Chart {
  /**
   * グラフデータとDOMデータのオフセットズレの補正値
   *
   * DOMデータは0〜6を仮定している。
   * 一方でグラフデータは-3〜3を仮定している。
   */
  static middle = 3

  /**
   * グラフ原点
   */
  public pointZero: Point = { x: 0, y: 0 }

  /**
   * DOMデータをグラフデータに変換する
   */
  static fromDom(v: DomValues): Point {
    const domToPoint = (dom: string) => {
      const num = parseInt(dom)
      return isNaN(num) ? NaN : num - TasteGraph.middle
    }
    return { x: domToPoint(v.taste), y: domToPoint(v.aroma) }
  }

  /**
   * グラフデータをDOMデータに変換する
   *
   * @param p - グラフデータ、ただし空グラフのときにNaNを含みうる
   * @returns 文字列変換されたDOMデータ
   */
  protected static toDom(p: Point): DomValues {
    const pointToDom = (num: number) => {
      const v = num + TasteGraph.middle
      return isNaN(v) ? "" : v.toString()
    }
    return { taste: pointToDom(p.x), aroma: pointToDom(p.y) }
  }

  /**
   * クリックした位置のグラフデータを取得する
   */
  protected static getClickData(event: ChartEvent, chart: Chart) {
    // @ts-expect-error chart.jsのhelperの都合のエラーを無視する
    const canvasPosition = getRelativePosition(event, chart)
    const x = chart.scales.x.getValueForPixel(canvasPosition.x) || NaN
    const y = chart.scales.y.getValueForPixel(canvasPosition.y) || NaN
    return { x: Math.round(x), y: Math.round(y) }
  }

  /**
   * グラフにデータを挿入する
   */
  protected static pushData(chart: Chart, data: Point) {
    chart.data.datasets[0].data.push(data)
  }

  /**
   * chart.jsのpopが返すunion型を、Point型だけにガードする
   */
  protected static isPoint(
    arg: number | [number, number] | Point | BubbleDataPoint | undefined | null
  ): arg is Point {
    return arg != null && typeof arg !== "number" && !("r" in arg) && "x" in arg
  }

  /**
   * グラフにデータを削除・取得する
   */
  protected static popData(chart: Chart): Point {
    const data = chart.data.datasets[0].data.pop()
    return TasteGraph.isPoint(data) ? data : { x: NaN, y: NaN }
  }

  /**
   * グラフデータの同値比較
   */
  protected static eqPoint(p1: Point, p2: Point) {
    return p1.x === p2.x && p1.y === p2.y
  }

  /**
   * @param canvas - グラフ描画先
   * @param dom - 描画するグラフの初期値
   * @param domCallback - クリックされた値に対するコールバック関数を与える。
   *                    この引数を与えると、クリックで入力可能なグラフになる。
   * @param config - グラフのカスタマイズ値
   */
  constructor({
    canvas,
    dom,
    domCallback,
    config,
  }: {
    canvas: HTMLCanvasElement
    dom: DomValues
    domCallback?: DomCallback
    config?: TasteGraphConfig
  }) {
    // --- Data ---
    const p = TasteGraph.fromDom(dom)
    const data = {
      datasets: [
        {
          data: [p],
          backgroundColor: "rgba(183, 40, 46, 0.9)",
          borderColor: "rgba(183, 40, 46, 1.0)",
          pointRadius: config?.pointRadius ?? 10,
        },
      ],
    }

    // --- Plugin ---
    type QuadrantsColors = {
      topRight: Color
      topLeft: Color
      bottomLeft: Color
      bottomRight: Color
    }
    /**
     * Quadrantsプラグイン
     *
     * 4象限を色分けする
     *
     * chart.js公式が紹介している
     * https://www.chartjs.org/docs/latest/samples/plugins/quadrants.html
     */
    const quadrants = {
      id: "quadrants",
      beforeDraw(
        chart: Chart,
        _args: { cancelable: boolean },
        options: QuadrantsColors
      ) {
        const {
          ctx,
          chartArea: { left, top, right, bottom },
          scales: { x, y },
        } = chart
        const midX = x.getPixelForValue(0)
        const midY = y.getPixelForValue(0)
        ctx.save()
        ctx.fillStyle = options.topLeft
        ctx.fillRect(left, top, midX - left, midY - top)
        ctx.fillStyle = options.topRight
        ctx.fillRect(midX, top, right - midX, midY - top)
        ctx.fillStyle = options.bottomRight
        ctx.fillRect(midX, midY, right - midX, bottom - midY)
        ctx.fillStyle = options.bottomLeft
        ctx.fillRect(left, midY, midX - left, bottom - midY)
        ctx.restore()
      },
    }
    // primary color: #19448e = 25,68,142
    const topRight = "rgba(25, 68, 142, 0.18)"
    const topLeft = "rgba(25, 68, 142, 0.09)"
    const bottomLeft = "rgba(25, 68, 142, 0.02)"
    const bottomRight = topLeft
    const plugins = {
      legend: { display: false },
      tooltip: { enabled: false },
      quadrants: {
        topRight,
        topLeft,
        bottomLeft,
        bottomRight,
      },
    }

    // --- Axis ---
    const margin = 0.2
    const minmax = TasteGraph.middle + margin
    const commonAxis = {
      title: { display: true, padding: 1 },
      max: minmax,
      min: -minmax,
      grid: { drawTicks: false }, // メモリ線のはみ出し
      ticks: { display: false }, // メモリ線のはみ出しの数値
    }
    const dummyAxis = merge(commonAxis, {
      grid: { display: false }, // グラフ内のメモリ線
      border: { display: false }, // 軸
    })
    const axis = merge(commonAxis, {
      grid: {
        lineWidth: (context: ScriptableScaleContext) => {
          const line = config?.lineWidth ?? 5
          // x=0/y=0だけ太くする
          return context.tick.value === 0 ? line : 1
        },
      },
      ticks: { maxTicksLimit: 3 }, // 原点と外周2線の合計3つ
    })
    /**
     * データを持つx軸
     */
    const x = merge(axis, {
      title: { text: "香りが低い" },
      position: "bottom",
    })
    /**
     * グラフ上方にテキスト表示するためのダミーx軸
     */
    const xTop = merge(dummyAxis, {
      title: { text: "香りが高い" },
      position: "top",
    })
    /**
     * データを持つy軸
     */
    const y = merge(axis, {
      title: { text: "味が淡い" },
      position: "left",
    })
    /**
     * グラフ右方にテキスト表示するためのダミーy軸
     */
    const yRight = merge(dummyAxis, {
      title: { text: "味が濃い" },
      position: "right",
    })

    // --- onClick ---
    /**
     * グラフクリックをしたときの動作
     *
     * 表示モードのときは、何もしない。
     * 入力モードのときは、クリック位置に一番近い整数値データを入力できる。
     * 既存のデータをクリックすると入力をリセットできる。
     */
    const onClick = (() => {
      if (typeof domCallback === "undefined")
        (_e: ChartEvent, _el: ActiveElement[], _c: Chart): void => {
          // dummy empty lambda
        }
      else {
        const syncDom = (data: Point) => {
          const d = TasteGraph.toDom(data)
          domCallback(d)
        }
        return (event: ChartEvent, _element: ActiveElement[], chart: Chart) => {
          const oldData = TasteGraph.popData(chart)
          let newData = TasteGraph.getClickData(event, chart)
          if (TasteGraph.eqPoint(oldData, newData)) newData = { x: NaN, y: NaN }
          else TasteGraph.pushData(chart, newData)
          syncDom(newData)
          chart.update()
        }
      }
    })() // if式風に使う

    // --- Options ---
    const options: ChartOptions = {
      scales: { x, xTop, y, yRight },
      animation: false,
      plugins,
      responsive: true,
      maintainAspectRatio: false,
      events: ["click"],
      onClick,
    }

    // --- Config ---
    const cconfig: ChartConfiguration = {
      type: "scatter",
      data,
      options,
      plugins: [quadrants],
    }

    super(canvas, cconfig)
  }
}
