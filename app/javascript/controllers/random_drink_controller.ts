import { Controller } from "@hotwired/stimulus"

type DrinkData = {
  id: number;
  name: string;
}

export default class extends Controller {
  static targets = ["button", "shuffle", "result"]


  declare readonly buttonTarget: HTMLButtonElement
  declare readonly shuffleTarget: HTMLElement
  declare readonly resultTarget: HTMLElement

  connect() {
    this.shuffleTarget.addEventListener("click", () => {
      this.pickRandomDrink()
    });
    this.buttonTarget.addEventListener("click", () => {
      this.pickRandomDrink()
    });
  }

  async pickRandomDrink(): Promise<void> {
    this.showLoadingIndicator()
    fetch("/sakes/random")
      .then((response) => response.json())
      .then((data) => this.displayRandomDrink(data))
      .catch((error) => console.error(error))
  }

  displayRandomDrink(data: DrinkData) {
    this.resultTarget.innerHTML = `
      <h3>${data.name}</h3>
      <a href="/sakes/${data.id}">詳細を見る</a>
    `
  }

  showLoadingIndicator() {
    this.resultTarget.innerHTML = `<p>Loading...</p>`
  }
}
