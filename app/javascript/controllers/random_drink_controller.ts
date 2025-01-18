import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  connect() {
    this.buttonTarget.addEventListener("click", this.pickRandomDrink.bind(this))
  }

  pickRandomDrink() {
    fetch("/sakes/random")
      .then(response => response.json())
      .then(data => {
        if (data.id) {
          window.location.href = `/sakes/${data.id}`
        }
      })
  }
}
