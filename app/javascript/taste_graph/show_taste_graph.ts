import { DomValues, TasteGraph } from "./taste_graph"

function getDomValues(canvas: HTMLCanvasElement): DomValues {
  const taste = canvas.dataset.tasteValue ?? ""
  const aroma = canvas.dataset.aromaValue ?? ""
  return { taste, aroma }
}

// Main
{
  const canvases = Array.from(document.getElementsByTagName("canvas"))
  const graphCanvases = canvases.filter((c) => c.hasAttribute("id"))
  const config = { pointRadius: 6, zeroLineWidth: 3 }
  graphCanvases.forEach((canvas) => {
    const dom = getDomValues(canvas)
    new TasteGraph({ canvas, dom, config })
  })
}
