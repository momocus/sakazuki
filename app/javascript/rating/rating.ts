import rater from "rater-js"

function getSakeRatingFromDOM(): number {
  const element = document.getElementById("sake_rating") as HTMLInputElement
  const ratingStr = element.getAttribute("value")
  if (ratingStr == null) return 0
  return parseInt(ratingStr) || 0
}

function setSakeRatingToDOM(rating: number) {
  const sakeRatingForm = document.getElementById(
    "sake_rating"
  ) as HTMLInputElement
  sakeRatingForm.setAttribute("value", rating.toString())
}

addEventListener("turbo:load", (_event) => {
  const element = document.getElementById("rater")

  if (element != null) {
    const sakeRater = rater({
      element,
      starSize: 32,
      rateCallback: function rateCallback(rating, done) {
        // reset 0, when pushing same star
        if (rating == sakeRater.getRating()) rating = 0

        sakeRater.setRating(rating)
        setSakeRatingToDOM(rating)

        if (done != null) done()
      },
    })
    const rating = getSakeRatingFromDOM()
    sakeRater.setRating(rating)
  }
})
