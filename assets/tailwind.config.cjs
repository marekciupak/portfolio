/*eslint-env node*/

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./js/**/*.{ts,tsx}", "../lib/*_web.ex", "../lib/*_web/**/*.*ex"],
  theme: {
    extend: {},
  },
  plugins: [],
};
