import { TasteGraph } from "./taste_graph"

// Main
{
  const canvas = document.getElementById("taste_graph") as HTMLCanvasElement
  const tasteElement = document.getElementById(
    "sake_taste_value"
  ) as HTMLInputElement
  const aromaElement = document.getElementById(
    "sake_aroma_value"
  ) as HTMLInputElement
  new TasteGraph(canvas, { tasteElement, aromaElement })
}
