import eslintConfigPrettier from "eslint-config-prettier/flat"
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

  // ESLintコアの設定
  pluginJs.configs.recommended,
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
  stylisticJs.configs.all,

  // eslint-config-prettierの設定
  eslintConfigPrettier,
]
