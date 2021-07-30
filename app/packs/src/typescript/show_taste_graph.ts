import { GraphP, TasteGraph } from "./taste_graph"

function getDomValueFromCanvas(canvas: HTMLCanvasElement): GraphP {
  const tasteS = canvas.dataset.tasteValue
  const aromaS = canvas.dataset.aromaValue
  // not (undefined or empty string)
  if (tasteS && aromaS) {
    const taste = parseInt(tasteS)
    const aroma = parseInt(aromaS)
    if (taste != NaN && aroma != NaN) return { x: taste, y: aroma }
  }
  // データがないなど、Domからデータが取れない場合
  return null
}

const hasCanvasID = (elem: HTMLCanvasElement): boolean => {
  const id = elem.getAttribute("id")
  return id != null
}

// Main
{
  const canvases = Array.from(document.getElementsByTagName("canvas"))
  const graphs = canvases.filter(hasCanvasID)
  graphs.forEach((canvas) => {
    const p = getDomValueFromCanvas(canvas)
    new TasteGraph(canvas, p, { pointRadius: 6, zeroLineWidth: 3 })
  })
}
