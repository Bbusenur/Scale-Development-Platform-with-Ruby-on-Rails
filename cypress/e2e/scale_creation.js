// cypress/e2e/scale_creation.js
// Cucumber (Gherkin) step definitions for scale_creation.feature

import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor';

// *** GIVEN ADIMLARI ***
Given('kullanıcı anasayfaya gider', () => {
  cy.visit('/');
  // Sayfanın yüklenmesini bekle
  cy.get('[data-testid="main-content"]').should('be.visible');
});

// *** WHEN ADIMLARI ***
When('kullanıcı {string} butonuna tıklar', (buttonText) => {
  // data-testid veya içerik ile butonu bul ve tıkla
  cy.contains('button', buttonText)
    .should('be.visible')
    .click();
});

When('kullanıcı {string} alanına {string} yazar', (fieldName, value) => {
  // data-testid ile input alanını bul ve değer gir
  cy.get(`[data-testid="${fieldName}-input"]`)
    .should('be.visible')
    .clear()
    .type(value);
});

// *** THEN ADIMLARI ***
Then('sistem {string} mesajını gösterir', (message) => {
  // Toast mesajını bul ve içeriğini kontrol et
  cy.get('[data-testid="toast-message"]')
    .should('be.visible')
    .and('contain', message);
});

Then('kullanıcı {string} sayfasına yönlendirilir', (pageName) => {
  // Sayfa yönlendirmelerini kontrol et
  const pageRoutes = {
    'Ölçek Listesi': '/scales',
    'Anasayfa': '/',
    'Ölçek Oluşturma': '/scales/new',
    'Anket Listesi': '/surveys',
    'Kullanıcı Profili': '/profile'
  };

  const expectedPath = pageRoutes[pageName];
  cy.url().should('include', expectedPath);
  
  // Sayfanın yüklendiğinden emin ol
  cy.get('[data-testid="main-content"]').should('be.visible');
});
