const { environment } = require("@rails/webpacker")

// Be able to resolve relative path in node_modules css.
// https://github.com/rails/webpacker/issues/2155
environment.loaders.get("sass").use.splice(-1, 0, {
  loader: "resolve-url-loader",
})

module.exports = environment
