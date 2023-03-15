import { TasteGraph } from "./taste_graph"
import type { DomValues } from "./taste_graph"

addEventListener("turbo:load", (_event) => {
  const canvas = document.getElementById("taste_graph") as HTMLCanvasElement
  const tasteElement = document.getElementById(
    "sake_taste_value"
  ) as HTMLInputElement
  const aromaElement = document.getElementById(
    "sake_aroma_value"
  ) as HTMLInputElement

  const taste = tasteElement.value
  const aroma = aromaElement.value
  const dom = { taste, aroma }
  const domCallback = (d: DomValues) => {
    tasteElement.value = d.taste
    aromaElement.value = d.aroma
  }
  new TasteGraph({ canvas, dom, domCallback })
})
