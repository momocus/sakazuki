module.exports = {
  env: {
    browser: true,
    es2020: true,
    node: true,
  },
  parserOptions: {
    ecmaVersion: "2020",
    sourceType: "module",
  },
  ignorePatterns: ["/coverage/", "/public/packs*"],
  plugins: [],
  extends: ["eslint:recommended", "prettier"],
  rules: {
    indent: ["error", 2],
    "linebreak-style": ["error", "unix"],
    quotes: ["error", "double", { avoidEscape: true }],
    semi: ["error", "never"],
  },
  overrides: [
    {
      files: ["*.ts", "*.tsx"],
      parser: "@typescript-eslint/parser",
      parserOptions: {
        tsconfigRootDir: ".",
        project: ["./tsconfig.json"],
      },
      plugins: ["@typescript-eslint"],
      extends: [
        "eslint:recommended",
        "plugin:@typescript-eslint/recommended",
        "plugin:@typescript-eslint/recommended-requiring-type-checking",
        "prettier",
      ],
      rules: {
        "@typescript-eslint/no-unused-vars": [
          "warn",
          { varsIgnorePattern: "^_", argsIgnorePattern: "^_" },
        ],
      },
    },
  ],
}
