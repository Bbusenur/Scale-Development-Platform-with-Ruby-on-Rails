// cypress.config.js
const { defineConfig } = require('cypress');
const { addCucumberPreprocessorPlugin } = require('@badeball/cypress-cucumber-preprocessor');
const createBundler = require('@bahmutov/cypress-esbuild-preprocessor');
const { createEsbuildPlugin } = require('@badeball/cypress-cucumber-preprocessor/esbuild');

module.exports = defineConfig({
  e2e: {
    specPattern: 'cypress/e2e/**/*.feature',
    baseUrl: 'http://localhost:3000',
    supportFile: 'cypress/support/e2e.js',

    async setupNodeEvents(on, config) {
      // 1. Cucumber Preprocessor eklentisini ekle
      await addCucumberPreprocessorPlugin(on, config);

      // 2. esbuild preprocessor'ı kullan ve cucumber plugin'ini ekle
      on(
        'file:preprocessor',
        createBundler({
          plugins: [
            createEsbuildPlugin(config, {
              prettySourceMap: false,
            }),
          ],
        })
      );

      return config;
    },
  },
});