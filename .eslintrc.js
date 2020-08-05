module.exports = {
  env: {
    browser: true,
    es2020: true,
  },
  extends: [
    'plugin:@typescript-eslint/recommended-requiring-type-checking',
    'plugin:prettier/recommended',
    'prettier/@typescript-eslint',
  ],
  parserOptions: {
    ecmaVersion: 11,
    sourceType: 'module',
    tsconfigRootDir: ".",
    project: ['./tsconfig.json'],
  },
  plugins: [
    '@typescript-eslint',
  ],
}
