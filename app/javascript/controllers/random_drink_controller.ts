import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "image"]

  declare readonly imageTarget: HTMLImageElement
  declare readonly buttonTarget: HTMLButtonElement

  connect() {
    this.imageTarget.addEventListener("click", this.pickRandomDrink.bind(this))
    this.buttonTarget.addEventListener("click", this.pickRandomDrink.bind(this))
  }

  async pickRandomDrink() {
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
    const resultContainer = document.getElementById("random-drink-result")
    if (resultContainer) {
      resultContainer.innerHTML = `
        <h3><a href="/sakes/${data.id}">${data.name}</a></h3>
      `
    }
  }
}