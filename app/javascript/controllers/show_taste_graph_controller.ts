import { Controller } from "@hotwired/stimulus"
import { TasteGraph } from "../taste_graph/taste_graph"
import type {
  DomValues,
  TasteGraphConfig,
  TasteGraphOptions,
} from "../taste_graph/taste_graph"

// Connects to data-controller="show-taste-graph"
export default class ShowTasteGraphController extends Controller<HTMLCanvasElement> {
  static values = {
    taste: String,
    aroma: String,
  }
  declare tasteValue: string
  declare aromaValue: string

  static targets = ["canvas"]
  declare readonly canvasTarget: HTMLCanvasElement

  connect() {
    const dom: DomValues = { taste: this.tasteValue, aroma: this.aromaValue }
    const config: TasteGraphConfig = { pointRadius: 6, zeroLineWidth: 3 }
    const opts: TasteGraphOptions = { config }
    new TasteGraph(this.canvasTarget, dom, opts)
  }
}
