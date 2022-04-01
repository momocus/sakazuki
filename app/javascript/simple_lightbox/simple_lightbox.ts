import SimpleLightbox from "simplelightbox"

// Main
{
  document.addEventListener("DOMContentLoaded", () => {
    new SimpleLightbox(".photo-gallery a", {
      fadeSpeed: 100,
      animationSlide: false,
      history: false,
      close: false,
    })
  })
}
