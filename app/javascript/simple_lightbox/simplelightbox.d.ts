// Type definitions for SimpleLightbox 2.9.0
// Project: https://github.com/andreknieriem/simplelightbox https://simplelightbox.com/
// Definitions by: SAITOU Keita <https://github.com/yonta>
// Definitions: https://github.com/DefinitelyTyped/DefinitelyTyped
// TypeScript Version 4.5.5

declare module "simplelightbox" {
  export default SimpleLightbox

  declare class SimpleLightbox {
    constructor(elements: string, options: SimpleLightbox.options)
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    on(events: string, callback: (arg: void | string) => any): SimpleLightbox
  }

  declare namespace SimpleLightbox {
    interface options {
      sourceAttr?: string
      overlay?: boolean
      spinner?: boolean
      nav?: boolean
      navText?: string[]
      captions?: boolean
      captionDelay?: number
      captionSelector?: string | (() => HTMLElement)
      captionType?: string
      captionsData?: string
      captionPosition?: string
      captionClass?: string
      close?: boolean
      closeText?: string
      swipeClose?: boolean
      showCounter?: boolean
      fileExt?: false | RegExp
      animationSlide?: boolean
      animationSpeed?: number
      preloading?: boolean
      enableKeyboard?: boolean
      loop?: boolean
      rel?: false | string
      docClose?: boolean
      swipeTolerance?: number
      className?: string
      widthRatio?: number
      heightRatio?: number
      scaleImageToRatio?: boolean
      disableRightClick?: boolean
      disableScroll?: boolean
      alertError?: boolean
      alertErrorMessage?: string
      additionalHtml?: boolean
      history?: boolean
      throttleInterval?: number
      doubleTapZoom?: number
      maxZoom?: number
      htmlClass?: string
      rtl?: boolean
      fixedClass?: string
      fadeSpeed?: number
      uniqueImages?: boolean
      focus?: boolean
      scrollZoom?: boolean
      scrollZoomFactor?: number
    }
  }
}
