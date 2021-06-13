// @ts-ignore
// TODO: @types/simplelightboxパッケージができたらインストールしてignoreコメントを削除する
//       .d.tsの独自実装もできるが、simplelightboxを利用する実装が小さいため今回はしない。
import SimpleLightbox from "simplelightbox"

{
  window.addEventListener("DOMContentLoaded", () => {
    /* eslint-disable @typescript-eslint/no-unsafe-call */
    new SimpleLightbox(".photo-gallery a", {
      fadeSpeed: 100,
      animationSlide: false,
      history: false,
    })
    /* eslint-enable @typescript-eslint/no-unsafe-call */
  })
}
