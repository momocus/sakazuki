import { GraphP, TasteGraph } from "./taste_graph"

function updateDomValue(data: GraphP): void {
  const x = data ? data.x.toString() : ""
  const y = data ? data.y.toString() : ""
  const tasteInput = document.getElementById(
    "sake_taste_value"
  ) as HTMLInputElement
  const aromaInput = document.getElementById(
    "sake_aroma_value"
  ) as HTMLInputElement
  tasteInput.setAttribute("value", x)
  aromaInput.setAttribute("value", y)
}

function getDomValue(): DomValues {
  const tasteInput = document.getElementById(
    "sake_taste_value"
  ) as HTMLInputElement
  const aromaInput = document.getElementById(
    "sake_aroma_value"
  ) as HTMLInputElement
  if (tasteInput.value && aromaInput.value) {
    const taste = parseInt(tasteInput.value)
    const aroma = parseInt(aromaInput.value)
    if (Number.isInteger(taste) && Number.isInteger(aroma))
      return { x: taste, y: aroma }
  }
  return null // データがない場合
}

{
  document.addEventListener("DOMContentLoaded", function () {
    const domData = getDomValue() // DOMから味・香りの値(0~6)を取る
    const canvas = document.getElementById("taste_graph") as HTMLCanvasElement
    const _graph = new TasteGraph(canvas, domData, {}, true, updateDomValue)
  })
}
