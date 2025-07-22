import { Controller } from "@hotwired/stimulus"
import { Tooltip } from "bootstrap"

// Connects to data-controller="tooltip"
export default class TooltipController extends Controller<HTMLSpanElement> {
  connect() {
    new Tooltip(this.element)
  }
}
