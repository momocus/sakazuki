import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "image", "result"]

  declare readonly imageTarget: HTMLImageElement
  declare readonly buttonTarget: HTMLButtonElement
  declare readonly resultTarget: HTMLElement

  connect() {
    this.imageTarget.addEventListener("click", this.pickRandomDrink.bind(this))
    this.buttonTarget.addEventListener("click", this.pickRandomDrink.bind(this))
  }

  async pickRandomDrink() {
    this.showLoadingIndicator()
    try {
      const response = await fetch("/sakes/random")
      const data = await response.json()
      if (data.id) {
        this.displayRandomDrink(data)
      }
    } catch (error) {
      console.error("Error fetching random drink:", error)
    }
  }

  displayRandomDrink(data: { id: number, name: string, description: string }) {
    this.resultTarget.innerHTML = `
      <h3>${data.name}</h3>
      <a href="/sakes/${data.id}">詳細を見る</a>
    `
  }

  showLoadingIndicator() {
    this.resultTarget.innerHTML = `<p>Loading...</p>`
  }
}