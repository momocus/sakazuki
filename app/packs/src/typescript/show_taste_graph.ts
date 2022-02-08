import { DomValues, TasteGraph } from "./taste_graph"

function getDomValues(canvas: HTMLCanvasElement): DomValues {
  const tasteS = canvas.dataset.tasteValue
  const aromaS = canvas.dataset.aromaValue
  // データがないやparse失敗など、Domからデータが取れない場合はNaN,NaNを返す
  return tasteS && aromaS
    ? { taste: parseInt(tasteS), arroma: parseInt(aromaS) }
    : { taste: NaN, arroma: NaN }
}

const hasCanvasID = (elem: HTMLCanvasElement): boolean => {
  const id = elem.getAttribute("id")
  return id != null
}

// Main
{
  document.addEventListener("turbolinks:load", function () {
    const canvases = Array.from(document.getElementsByTagName("canvas"))
    const graphs = canvases.filter(hasCanvasID)
    const config = { pointRadius: 6, zeroLineWidth: 3 }
    graphs.forEach((canvas) => {
      const { taste, arroma } = getDomValues(canvas)
      new TasteGraph(canvas, taste, arroma, config)
    })
  })
}
