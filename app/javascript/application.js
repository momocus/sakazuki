// Entry point for the build script in your package.json
/* eslint-env node */
const Rails = require("@rails/ujs")
Rails.start()

import { Alert, Collapse } from "bootstrap"
const alertElementList = document.querySelectorAll(".alert")
alertElementList.forEach((element) => {
  new Alert(element)
})
const collapseElementList = document.querySelectorAll(".collapse")
collapseElementList.forEach((element) => {
  new Collapse(element)
})
