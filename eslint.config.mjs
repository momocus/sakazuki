import eslintConfigPrettier from "eslint-config-prettier/flat"
import globals from "globals"
import tseslint from "typescript-eslint"
import eslint from "@eslint/js"
import stylisticJs from "@stylistic/eslint-plugin-js"

export default tseslint.config(
  // 対象ファイル
  { files: ["**/*.{js,mjs,cjs,ts}"] },

  // ブラウザ環境を有効化
  { languageOptions: { globals: globals.browser } },

  // 必要ないイラインディレクティブをエラーに
  {
    linterOptions: {
      reportUnusedDisableDirectives: "error",
      reportUnusedInlineConfigs: "error",
    },
  },

  // ESLintコアの設定
  eslint.configs.recommended,
  {
    rules: {
      "no-unused-vars": [
        "error",
        { varsIgnorePattern: "^_", argsIgnorePattern: "^_" },
      ],
    },
  },

  // @stylistic/eslint-plugin-jsの設定
  stylisticJs.configs.all,

  // typescript-eslintの設定
  tseslint.configs.strictTypeChecked,
  tseslint.configs.stylisticTypeChecked,
  {
    plugins: {
      "@typescript-eslint": tseslint.plugin,
    },

    languageOptions: {
      parser: tseslint.parser,
      parserOptions: {
        projectService: true,
      },
    },

    rules: {
      "@typescript-eslint/no-unused-vars": [
        "error",
        {
          varsIgnorePattern: "^_",
          argsIgnorePattern: "^_",
        },
      ],
      "@typescript-eslint/consistent-type-imports": "error",
      "@typescript-eslint/consistent-type-definitions": ["error", "type"],
    },
  },

  {
    files: ["**/*.{js,mjs,cjs}"],
    extends: [tseslint.configs.disableTypeChecked],
  },

  // eslint-config-prettierの設定
  eslintConfigPrettier,
)
