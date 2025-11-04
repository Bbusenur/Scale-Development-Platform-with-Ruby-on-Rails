// cypress/e2e/survey_creation.js
// Cucumber (Gherkin) step definitions for survey_creation.feature

import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor';

// *** GIVEN ADIMLARI ***
Given('kullanıcı giriş yapmıştır', () => {
    // Login işlemi
    cy.visit('/login');
    cy.get('[data-testid="email-input"]').type('test@example.com');
    cy.get('[data-testid="password-input"]').type('password123');
    cy.get('[data-testid="login-button"]').click();
    
    // Login başarılı mı kontrol et
    cy.get('[data-testid="user-menu"]').should('be.visible');
});

Given('kullanıcı bir ölçeğe sahiptir', () => {
    // Ölçekler sayfasına git
    cy.visit('/scales');
    
    // En az bir ölçek olduğunu kontrol et
    cy.get('[data-testid="scale-item"]').should('have.length.at.least', 1);
    
    // İlk ölçeği seç
    cy.get('[data-testid="scale-select"]').click();
    cy.get('[data-testid="scale-option"]').first().click();
});

Given('kullanıcının kredi bakiyesi {int} kredidir', (creditAmount) => {
    // Kredi bakiyesi kontrolü
    cy.get('[data-testid="credit-balance"]')
        .should('be.visible')
        .and('contain', creditAmount);
});

// *** WHEN ADIMLARI ***
When('kullanıcı {string} sayfasına gider', (pageName) => {
    const pageRoutes = {
        'Anket Oluştur': '/surveys/new',
        'Anket Listesi': '/surveys',
        'Ölçek Listesi': '/scales'
    };

    const route = pageRoutes[pageName] || '/';
    cy.visit(route);
    
    // Sayfa yüklenme kontrolü
    cy.get('[data-testid="main-content"]').should('be.visible');
    
    // Sayfa başlığı kontrolü
    cy.get('[data-testid="page-title"]').should('contain', pageName);
});

When('kullanıcı {string} alanına {string} yazar', (fieldName, value) => {
    // data-testid ile input alanını bul
    cy.get(`[data-testid="${fieldName}-input"]`)
        .should('be.visible')
        .clear()
        .type(value);
});

When('kullanıcı {string} butonuna tıklar', (buttonText) => {
    // Buton metni ile butonu bul ve tıkla
    cy.contains('button', buttonText)
        .should('be.visible')
        .click();
});

// *** THEN ADIMLARI ***
Then('sistem {string} mesajını gösterir', (message) => {
    // Başarı mesajını kontrol et
    cy.get('[data-testid="toast-message"]')
        .should('be.visible')
        .and('contain', message);
});

Then('sistem {string} hata mesajını gösterir', (errorMessage) => {
    // Hata mesajını kontrol et
    cy.get('[data-testid="error-message"]')
        .should('be.visible')
        .and('contain', errorMessage);
});

Then('kullanıcı kredi bakiyesinin düştüğünü doğrular', () => {
    // Önceki kredi miktarını al
    let previousCredit;
    cy.get('[data-testid="credit-balance"]')
        .invoke('text')
        .then((text) => {
            previousCredit = parseInt(text);
        });
    
    // İşlem sonrası kredi bakiyesinin düştüğünü kontrol et
    cy.get('[data-testid="credit-balance"]')
        .should(($balance) => {
            const currentCredit = parseInt($balance.text());
            expect(currentCredit).to.be.lessThan(previousCredit);
        });
});

