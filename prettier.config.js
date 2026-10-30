/** @type {import('prettier').Config} */
export default {
  printWidth: 120,
  singleQuote: true,
  overrides: [
    {
      files: '*.html',
      options: { parser: 'angular' },
    },
  ],
};
