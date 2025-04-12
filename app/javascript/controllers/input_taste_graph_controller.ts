import { Controller } from "@hotwired/stimulus"
import { TasteGraph } from "../taste_graph/taste_graph"
import type {
  DomValues,
  DomCallback,
  TasteGraphOptions,
} from "../taste_graph/taste_graph"

// Connects to data-controller="input-taste-graph"
export default class InputTasteGraphController extends Controller<HTMLDivElement> {
  static targets = ["canvas", "taste", "aroma"]

  declare readonly canvasTarget: HTMLCanvasElement

  declare readonly tasteTarget: HTMLInputElement

  declare readonly aromaTarget: HTMLInputElement

  connect() {
    const dom: DomValues = {
      taste: this.tasteTarget.value,
      aroma: this.aromaTarget.value,
    }
    const domCallback: DomCallback = ({
      taste,
      aroma,
    }: Readonly<DomValues>) => {
      this.tasteTarget.value = taste
      this.aromaTarget.value = aroma
    }
    const opts: TasteGraphOptions = { domCallback }
    new TasteGraph(this.canvasTarget, dom, opts)
  }
}
