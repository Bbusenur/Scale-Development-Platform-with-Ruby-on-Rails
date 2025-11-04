// cypress/e2e/user_management.js
// Cucumber (Gherkin) step definitions for user_management.feature

import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor';

// *** GIVEN ADIMLARI ***
Given('kullanıcı kullanıcı kayıt sayfasına gider', () => {
    // Kayıt sayfasına git
    cy.visit('/signup');
    
    // Sayfanın yüklendiğini kontrol et
    cy.get('[data-testid="signup-form"]').should('be.visible');
    cy.get('[data-testid="page-title"]').should('contain', 'Kayıt Ol');
});

Given('kullanıcı giriş yapmıştır', () => {
    // Login sayfasına git
    cy.visit('/login');
    
    // Giriş bilgilerini doldur
    cy.get('[data-testid="email-input"]').type('test@example.com');
    cy.get('[data-testid="password-input"]').type('password123');
    cy.get('[data-testid="login-button"]').click();
    
    // Giriş başarılı mı kontrol et
    cy.get('[data-testid="user-menu"]').should('be.visible');
});

// *** WHEN ADIMLARI ***
When('kullanıcı {string} alanına {string} yazar', (fieldName, value) => {
    // Input alanını bul ve değer gir
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

When('kullanıcı {string} sayfasına gider', (pageName) => {
    const pageRoutes = {
        'Profil': '/profile',
        'Kullanıcı Listesi': '/users',
        'Anasayfa': '/',
        'Ayarlar': '/settings'
    };

    const route = pageRoutes[pageName] || '/';
    cy.visit(route);
    
    // Sayfa yüklenme kontrolü
    cy.get('[data-testid="main-content"]').should('be.visible');
    
    // Sayfa başlığı kontrolü
    cy.get('[data-testid="page-title"]').should('contain', pageName);
});

// *** THEN ADIMLARI ***
Then('sistem {string} mesajını gösterir', (message) => {
    // Başarı mesajını kontrol et
    cy.get('[data-testid="toast-message"]')
        .should('be.visible')
        .and('contain', message);
});

Then('kullanıcı kredi bakiyesinin görüntülendiğini doğrular', () => {
    // Kredi bakiyesi görüntüleme kontrolü
    cy.get('[data-testid="credit-balance"]')
        .should('be.visible')
        .and('not.be.empty');
});

Then('kredi bakiyesi {string} gösterir', (condition) => {
    // Kredi bakiyesi değer kontrolü
    cy.get('[data-testid="credit-balance"]')
        .should('be.visible')
        .invoke('text')
        .then((text) => {
            const balance = parseFloat(text);
            if (condition.includes('pozitif')) {
                expect(balance).to.be.gt(0);
            } else if (condition.includes('sıfır')) {
                expect(balance).to.equal(0);
            }
        });
});

Then('kredi bakiyesi 0 veya pozitif bir değer gösterir', () => {
    // Kredi bakiyesi pozitif değer kontrolü
    cy.get('[data-testid="credit-balance"]')
        .should('be.visible')
        .invoke('text')
        .then((text) => {
            const balance = parseFloat(text);
            expect(balance).to.be.gte(0);
        });
});

