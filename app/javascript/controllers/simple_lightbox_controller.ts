import { Controller } from "@hotwired/stimulus"
import SimpleLightbox from "simplelightbox"

// Connects to data-controller="simple-lightbox"
export default class SimpleLightboxController extends Controller<HTMLDivElement> {
  connect() {
    new SimpleLightbox(".photo-gallery a", {
      fadeSpeed: 100,
      animationSlide: false,
      history: false,
      close: false,
      fileExt: false,
    })
  }
}
