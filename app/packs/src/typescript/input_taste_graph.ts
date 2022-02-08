import { DomValues, TasteGraph } from "./taste_graph"

function updateDomValue(data: DomValues): void {
  const x = isNaN(data.taste) ? "" : data.taste.toString()
  const y = isNaN(data.arroma) ? "" : data.arroma.toString()
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
  if (tasteInput.value && aromaInput.value)
    return {
      taste: parseInt(tasteInput.value),
      arroma: parseInt(aromaInput.value),
    }
  // データがない場合
  return { taste: NaN, arroma: NaN }
}

{
  document.addEventListener("DOMContentLoaded", function () {
    const { taste, arroma } = getDomValue() // DOMから味・香りの値(0~6)を取る
    const canvas = document.getElementById("taste_graph") as HTMLCanvasElement
    new TasteGraph(canvas, taste, arroma, {}, true, updateDomValue)
  })
}
