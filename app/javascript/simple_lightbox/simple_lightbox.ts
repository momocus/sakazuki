import SimpleLightbox from "simplelightbox"

addEventListener("turbo:load", (_event) => {
  new SimpleLightbox(".photo-gallery a", {
    fadeSpeed: 100,
    animationSlide: false,
    history: false,
    close: false,
    fileExt: false,
  })
})
