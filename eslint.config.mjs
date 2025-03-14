import globals from "globals"
import pluginJs from "@eslint/js"
import stylisticJs from "@stylistic/eslint-plugin-js"
import tseslint from "typescript-eslint"

/** @type {import('eslint').Linter.Config[]} */
export default [
  // 対象ファイル
  { files: ["**/*.{js,mjs,cjs,ts}"] },

  // ブラウザ環境を有効化
  { languageOptions: { globals: globals.browser } },

  {
    linterOptions: {
      reportUnusedDisableDirectives: "error",
      reportUnusedInlineConfigs: "error",
    },
  },

  // ESLintコアの推奨デフォルト
  pluginJs.configs.recommended,

  // ESLintコアの追加・変更ルール
  {
    rules: {
      "no-unused-vars": [
        "error",
        { varsIgnorePattern: "^_", argsIgnorePattern: "^_" },
      ],
    },
  },

  ...tseslint.configs.recommended,

  // @stylistic-plugin-jsの設定
  {
    plugins: {
      "@stylistic/js": stylisticJs,
    },
    rules: {
      "@stylistic/js/indent": ["error", 2],
      "@stylistic/js/linebreak-style": ["error", "unix"],
      "@stylistic/js/quotes": ["error", "double", { avoidEscape: true }],
      "@stylistic/js/semi": ["error", "never"],
    },
  },
]
