import { Controller } from "@hotwired/stimulus"
import rater from "rater-js"

// Connects to data-controller="rating"
export default class RatingController extends Controller<HTMLFieldSetElement> {
  static targets = ["score", "location"]
  declare readonly scoreTarget: HTMLInputElement
  declare readonly locationTarget: HTMLDivElement

  connect() {
    const rating = parseInt(this.scoreTarget.value)
    const sakeRater = rater({
      element: this.locationTarget,
      rateCallback: (newRating, done) => {
        // reset 0, when pushing same star
        if (newRating === sakeRater.getRating()) newRating = 0

        sakeRater.setRating(newRating)
        this.scoreTarget.value = newRating.toString()

        if (done != null) done()
      },
      rating,
      starSize: 32,
    })
  }
}
