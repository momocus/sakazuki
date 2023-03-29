import { DomValues, TasteGraph } from "./taste_graph"

function getDomValues(canvas: HTMLCanvasElement): DomValues {
  const taste = canvas.dataset.tasteValue ?? ""
  const aroma = canvas.dataset.aromaValue ?? ""
  return { taste, aroma }
}

function hasSakeId(canvas: HTMLCanvasElement): boolean {
  const idRegexp = /^sake-\d+$/
  return canvas.id.match(idRegexp) != null
}

addEventListener("turbo:load", (_event) => {
  const canvases = Array.from(document.getElementsByTagName("canvas"))

  if (canvases.length > 0) {
    const graphCanvases = canvases.filter((c) => hasSakeId(c))
    const config = { pointRadius: 6, zeroLineWidth: 3 }
    graphCanvases.forEach((canvas) => {
      const dom = getDomValues(canvas)
      new TasteGraph({ canvas, dom, config })
    })
  }
})
