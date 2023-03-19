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
      rateCallback: (rating, done) => {
        // reset 0, when pushing same star
        if (rating === sakeRater.getRating()) rating = 0

        sakeRater.setRating(rating)
        this.scoreTarget.value = rating.toString()

        if (done != null) done()
      },
      rating,
      starSize: 32,
    })
  }
}
