import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="share"
export default class ShareController extends Controller<HTMLDivElement> {
  static values = {
    title: String,
    url: String,
  }

  declare readonly titleValue: string

  declare readonly urlValue: string

  static targets = ["text", "link"]

  declare readonly textTarget: HTMLTextAreaElement

  declare readonly linkTarget: HTMLAnchorElement

  connect() {
    const data: ShareData = {
      title: this.titleValue,
      text: this.textTarget.value,
      url: this.urlValue,
    }
    this.linkTarget.addEventListener("click", () => void navigator.share(data))
  }
}
