// cypress/e2e/response_collection.js
// Cucumber (Gherkin) step definitions for response_collection.feature

import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor';

// *** GIVEN ADIMLARI ***
Given('kullanıcı bir ankete erişebilir durumdadır', () => {
    // Test anketine git ve yüklenmesini bekle
    cy.visit('/surveys/1');
    cy.get('[data-testid="survey-form"]').should('be.visible');
});

Given('kullanıcı giriş yapmıştır', () => {
    // Login işlemi
    cy.visit('/login');
    cy.get('[data-testid="email-input"]').type('test@example.com');
    cy.get('[data-testid="password-input"]').type('password123');
    cy.get('[data-testid="login-button"]').click();
    
    // Login başarılı mı kontrol et
    cy.get('[data-testid="user-menu"]').should('be.visible');
});

Given('kullanıcının kredi bakiyesi {int} kredidir', (creditAmount) => {
    // Kredi bakiyesi kontrolü
    cy.get('[data-testid="credit-balance"]')
        .should('be.visible')
        .and('contain', creditAmount);
});

Given('kullanıcı bir ankete erişir', () => {
    cy.visit('/surveys/1');
    cy.get('[data-testid="survey-form"]').should('be.visible');
});

// *** WHEN ADIMLARI ***
When('kullanıcı ankette soruları cevaplar', () => {
    // Her soru tipine göre cevaplama
    cy.get('[data-testid^="question-"]').each(($question) => {
        const questionType = $question.attr('data-question-type');
        const questionId = $question.attr('data-testid');
        
        switch(questionType) {
            case 'likert':
                cy.get(`[data-testid="${questionId}-option-3"]`).click(); // Orta seçenek
                break;
            case 'multiple_choice':
                cy.get(`[data-testid="${questionId}-option-0"]`).click(); // İlk seçenek
                break;
            case 'text':
                cy.get(`[data-testid="${questionId}-input"]`).type('Test cevabı');
                break;
            case 'checkbox':
                cy.get(`[data-testid="${questionId}-option-0"]`).click(); // İlk seçenek
                break;
        }
    });
});

When('kullanıcı soruları cevaplar', () => {
    // Her soruyu otomatik cevapla
    cy.get('[data-testid^="question-"]').each(($question) => {
        const questionType = $question.attr('data-question-type');
        const questionId = $question.attr('data-testid');
        
        if (questionType === 'likert') {
            cy.get(`[data-testid="${questionId}-option-3"]`).click();
        } else {
            cy.get(`[data-testid="${questionId}-option-0"]`).click();
        }
    });
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

Then('kullanıcı kredi bakiyesinin {int} kredi düştüğünü doğrular', (creditAmount) => {
    // Önceki kredi miktarını al
    let previousCredit;
    cy.get('[data-testid="credit-balance"]')
        .invoke('text')
        .then((text) => {
            previousCredit = parseInt(text);
        });
    
    // Kredi düşüşünü kontrol et
    cy.get('[data-testid="credit-balance"]')
        .should(($balance) => {
            const currentCredit = parseInt($balance.text());
            expect(currentCredit).to.equal(previousCredit - creditAmount);
        });
});

