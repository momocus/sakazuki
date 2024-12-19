import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sake-size"
export default class SakeSizeController extends Controller<HTMLDivElement> {
  static targets = ["radio", "otherRadio", "otherSize", "size"]
  declare readonly radioTargets: HTMLInputElement[]
  declare readonly otherRadioTarget: HTMLInputElement
  declare readonly otherSizeTarget: HTMLInputElement
  declare readonly sizeTarget: HTMLInputElement

  updateOtherSizeEnablement(): void {
    this.otherSizeTarget.disabled = !this.otherRadioTarget.checked
    this.otherSizeTarget.required = this.otherRadioTarget.checked
  }

  writeHiddenWithOtherSize(): void {
    this.sizeTarget.value = this.otherSizeTarget.value
  }

  writeHiddenByRadio(event: Event): void {
    const elem = event.currentTarget as HTMLInputElement
    const size = elem.dataset.sakeSize
    if (size == null) return // error

    if (size == "other") this.writeHiddenWithOtherSize()
    else this.sizeTarget.value = size
  }

  private writeOtherSizeWithHidden(): void {
    this.otherSizeTarget.value = this.sizeTarget.value
  }

  private readHiddenSize(): void {
    const hiddenSize = this.sizeTarget.value
    const matchedRadio = this.radioTargets.find(
      (elem) => elem.dataset.sakeSize == hiddenSize,
    )

    // 選択肢にないサイズでフォームを埋める
    if (matchedRadio == null) this.writeOtherSizeWithHidden()

    // 酒サイズに合うradioにチェックをつける
    const radio = matchedRadio ?? this.otherSizeTarget
    radio.checked = true

    this.updateOtherSizeEnablement()
  }

  connect() {
    this.readHiddenSize()
  }
}
