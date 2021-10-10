// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

/* eslint-disable
   @typescript-eslint/no-unsafe-member-access,
   @typescript-eslint/no-unsafe-call */
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()
/* eslint-enable
   @typescript-eslint/no-unsafe-member-access,
   @typescript-eslint/no-unsafe-call */

// js
import "../src/javascript/bootstrap_plugins.js"

// style
import "bootstrap-icons/font/bootstrap-icons"

// image
import "images/choko.svg"
// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
/* eslint-disable
   @typescript-eslint/no-unsafe-call,
   @typescript-eslint/no-unsafe-assignment,
   @typescript-eslint/no-unused-vars-experimental */
const images = require.context("../images", true)
/* eslint-enable
   @typescript-eslint/no-unused-vars-experimental,
   @typescript-eslint/no-unsafe-assignment,
   @typescript-eslint/no-unsafe-call */
// const imagePath = (name) => images(name, true)
