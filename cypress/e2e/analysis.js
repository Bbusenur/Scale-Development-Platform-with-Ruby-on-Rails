// cypress/e2e/analysis.js
// Cucumber (Gherkin) step definitions for analysis.feature

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

Given('kullanıcı bir ankete sahiptir', () => {
    // Anketler sayfasına git
    cy.visit('/surveys');
    
    // En az bir anket olduğunu kontrol et
    cy.get('[data-testid="survey-item"]')
        .should('be.visible')
        .and('have.length.at.least', 1);
});

Given('kullanıcının yeterli kredisi vardır', () => {
    // Kredi bakiyesi kontrolü
    cy.get('[data-testid="credit-balance"]')
        .should('be.visible')
        .invoke('text')
        .then((text) => {
            const credit = parseInt(text);
            expect(credit).to.be.at.least(10); // Minimum gerekli kredi
        });
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
        'Analiz Başlat': '/analysis/new',
        'Analiz Listesi': '/analysis',
        'Anket Listesi': '/surveys'
    };

    const route = pageRoutes[pageName] || '/';
    cy.visit(route);
    
    // Sayfa yüklenme kontrolü
    cy.get('[data-testid="main-content"]').should('be.visible');
    
    // Sayfa başlığı kontrolü
    cy.get('[data-testid="page-title"]').should('contain', pageName);
});

When('kullanıcı {string} alanına {string} seçer', (fieldName, value) => {
    // Select elementini bul
    cy.get(`[data-testid="${fieldName}-select"]`)
        .should('be.visible')
        .click();
    
    // Seçeneği seç
    cy.get(`[data-testid="${fieldName}-option-${value}"]`)
        .should('be.visible')
        .click();
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

Then('kullanıcı analiz durumunu görüntüleyebilir', () => {
    // Analiz durumu görüntüleme kontrolü
    cy.get('[data-testid="analysis-status"]')
        .should('be.visible');
    
    // Analiz detayları kontrolü
    cy.get('[data-testid="analysis-details"]')
        .should('be.visible')
        .within(() => {
            cy.get('[data-testid="analysis-progress"]').should('be.visible');
            cy.get('[data-testid="analysis-results"]').should('exist');
        });
});

