import { TasteGraph } from "./taste_graph"

addEventListener("turbo:load", (_event) => {
  const canvas = document.getElementById(
    "taste_graph"
  ) as HTMLCanvasElement | null

  if (canvas != null) {
    const tasteElement = document.getElementById(
      "sake_taste_value"
    ) as HTMLInputElement
    const aromaElement = document.getElementById(
      "sake_aroma_value"
    ) as HTMLInputElement
    new TasteGraph(canvas, { tasteElement, aromaElement })
  }
})
