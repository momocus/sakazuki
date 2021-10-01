/*
  @types/simplelightboxが存在しない。
  コンストラクタしか使わないため、.d.tsの独自実装もしない。
*/
import SimpleLightbox from "simplelightbox"

// Main
{
  document.addEventListener("DOMContentLoaded", function () {
    /* eslint-disable @typescript-eslint/no-unsafe-call */
    new SimpleLightbox(".photo-gallery a", {
      fadeSpeed: 100,
      animationSlide: false,
      history: false,
      close: false,
    })
  })
}
