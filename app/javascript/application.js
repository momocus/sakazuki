// Entry point for the build script in your package.json
/* eslint-env node */
const Rails = require("@rails/ujs")
Rails.start()

import "bootstrap"
/*
 * MEMO: 下記import構文のほうがESMとして良い。
 *       公式ドキュメントでも推奨されている方法である。
 *       しかし、この構文を使うと、ページ開始時にnavbvarが開いた状態になってしまう。
 *
 * Bootstrap日本語ドキュメント
 * https://getbootstrap.jp/docs/5.0/getting-started/webpack/#javascript-%E3%82%A4%E3%83%B3%E3%83%9D%E3%83%BC%E3%83%88
 *
 * ESMに従ったimport構文
 * import { Alert, Collapse } from "bootstrap"
 * https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Statements/import
 */

const alertElementList = document.querySelectorAll(".alert")
alertElementList.forEach((element) => {
  /* eslint-disable-next-line no-undef */
  new Alert(element)
})

const collapseElementList = document.querySelectorAll(".collapse")
collapseElementList.forEach((element) => {
  /* eslint-disable-next-line no-undef */
  new Collapse(element)
})

const dropdownElementList = document.querySelectorAll(".dropdown-toggle")
dropdownElementList.forEach((element) => {
  /* eslint-disable-next-line no-undef */
  new Dropdown(element)
})
