// webpack.config.js
const path = require('path');
const { defineConfig } = require('webpack');

// Loader'ın bulunduğu tam yolu hesaplayın
const cucumberLoaderPath = path.resolve(
  __dirname,
  'node_modules',
  '@badeball',
  'cypress-cucumber-preprocessor',
  // 👇 Sadece burayı 'lib' yerine 'dist' olarak değiştirdik 👇
  'dist',
  'webpack-loader.js'
);

module.exports = {
  resolve: {
    extensions: ['.ts', '.js'],
  },
  module: {
    rules: [
      {
        test: /\.feature$/,
        use: [
          {
            loader: cucumberLoaderPath,
            options: {
              stepDefinitions: path.resolve(__dirname, 'cypress/e2e'),
            },
          },
        ],
      },
    ],
  },
};