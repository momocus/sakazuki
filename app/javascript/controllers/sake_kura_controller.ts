import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sake-kura"
export default class SakeKuraController extends Controller<HTMLDivElement> {
  static targets = ["kura", "todofuken", "mixed"]
  declare readonly kuraTarget: HTMLInputElement
  declare readonly todofukenTarget: HTMLInputElement
  declare readonly mixedTarget: HTMLInputElement

  private loadKuraTodofuken() {
    this.mixedTarget.value =
      this.kuraTarget.value && this.todofukenTarget.value
        ? `${this.kuraTarget.value}（${this.todofukenTarget.value}）`
        : this.kuraTarget.value
  }

  private stripKuraTodofuken(kuraTodofuken: string) {
    // フォーマットは"蔵名（県名）"
    const formatRegexp = /^([^（]+)（([^）]+)）$/
    const result = formatRegexp.exec(kuraTodofuken)

    if (result && result[1] && result[2]) return [result[1], result[2]]
    else return [kuraTodofuken, ""]
  }

  private setSyncEvent() {
    this.mixedTarget.addEventListener("change", (_event) => {
      const autocompeted = this.mixedTarget.value
      const [kura, todofuken] = this.stripKuraTodofuken(autocompeted)
      this.kuraTarget.value = kura
      this.todofukenTarget.value = todofuken
    })
  }

  connect() {
    this.loadKuraTodofuken()
    this.setSyncEvent()
  }
}
