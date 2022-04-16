import { DomValues, TasteGraph } from "./taste_graph"

function getDomValues(canvas: HTMLCanvasElement): DomValues {
  const tasteS = canvas.dataset.tasteValue
  const aromaS = canvas.dataset.aromaValue
  // データがないやparse失敗など、Domからデータが取れない場合はNaN,NaNを返す
  return tasteS && aromaS
    ? { taste: parseInt(tasteS), aroma: parseInt(aromaS) }
    : { taste: NaN, aroma: NaN }
}

const hasCanvasID = (elem: HTMLCanvasElement): boolean => {
  const id = elem.getAttribute("id")
  return id != null
}

// Main
{
  const canvases = Array.from(document.getElementsByTagName("canvas"))
  const graphs = canvases.filter(hasCanvasID)
  const config = { pointRadius: 6, zeroLineWidth: 3 }
  graphs.forEach((canvas) => {
    const { taste, aroma } = getDomValues(canvas)
    new TasteGraph(canvas, taste, aroma, config)
  })
}
