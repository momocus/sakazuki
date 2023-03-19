import { Controller } from "@hotwired/stimulus"
import * as meigaras from "../autocompletion/meigaras"

interface MeigarasHash {
  [index: string]: string
}

// Connects to data-controller="complete-meigara"
export default class CompleteMeigaraController extends Controller {
  static targets = ["name", "kura"]
  declare readonly nameTarget: HTMLInputElement
  declare readonly kuraTarget: HTMLInputElement

  private checkMeigara(words: Array<string>, meigaras: MeigarasHash): string {
    const matched_words = words
      .map((word) => {
        return meigaras[word]
      })
      .filter((word) => {
        return word
      })

    if (matched_words.length == 1) return matched_words[0]
    else return ""
  }

  connect() {
    this.nameTarget.addEventListener("change", (_event) => {
      // まだ蔵が入力されてないときに補完を試みる
      if (this.kuraTarget.value == "") {
        const name = this.nameTarget.value
        const words = name.split(RegExp(/\s/))
        const completion = this.checkMeigara(words, meigaras.dict)
        this.kuraTarget.value = completion
        // changeイベントを発火する
        this.kuraTarget.dispatchEvent(new Event("change"))
      }
    })
  }
}
