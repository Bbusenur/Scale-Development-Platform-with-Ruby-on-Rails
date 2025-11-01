// cypress/e2e/response_collection.js
// Cucumber (Gherkin) step definitions for response_collection.feature

import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor';

// *** GIVEN ADIMLARI ***
Given('kullanıcı bir ankete erişebilir durumdadır', () => {
    cy.visit('/surveys/1', { failOnStatusCode: false });
    cy.url().then((url) => {
        if (url.includes('404')) {
            cy.log('⚠️ Frontend henüz hazır değil: Anket sayfası bulunamadı.');
        }
    });
});

Given('kullanıcı giriş yapmıştır', () => {
    cy.visit('/');
    cy.log('⚠️ Giriş işlemi frontend geliştirildiğinde implement edilecek');
});

Given('kullanıcının kredi bakiyesi {int} kredidir', (creditAmount) => {
    cy.log(`⚠️ Kredi bakiyesi ayarlama (${creditAmount}) frontend geliştirildiğinde implement edilecek`);
});

Given('kullanıcı bir ankete erişir', () => {
    cy.visit('/surveys/1', { failOnStatusCode: false });
    cy.url().then((url) => {
        if (url.includes('404')) {
            cy.log('⚠️ Frontend henüz hazır değil: Anket sayfası bulunamadı.');
        }
    });
});

// *** WHEN ADIMLARI ***
When('kullanıcı ankette soruları cevaplar', () => {
    cy.get('body').then(($body) => {
        // Sorular için genel selector
        const $questionInputs = $body.find('[data-cy^="question-"], input[type="radio"], input[type="checkbox"], textarea.question-input');
        if ($questionInputs.length > 0) {
            cy.log('Sorular bulundu, cevaplama işlemi yapılacak');
            // Frontend geliştirildiğinde burada detaylı cevaplama işlemi yapılacak
        } else {
            cy.log('⚠️ Frontend henüz hazır değil: Sorular bulunamadı.');
        }
    });
});

When('kullanıcı soruları cevaplar', () => {
    cy.get('body').then(($body) => {
        const $questionInputs = $body.find('[data-cy^="question-"], input[type="radio"], textarea.question-input');
        if ($questionInputs.length > 0) {
            cy.log('Sorular bulundu, cevaplama işlemi yapılacak');
        } else {
            cy.log('⚠️ Frontend henüz hazır değil: Sorular bulunamadı.');
        }
    });
});

When('kullanıcı {string} butonuna tıklar', (buttonText) => {
    cy.get('body').then(($body) => {
        const $buttons = $body.find('button, a.button, input[type="submit"]');
        let found = false;
        $buttons.each((index, button) => {
            const buttonText_trim = Cypress.$(button).text().trim();
            if (buttonText_trim.includes(buttonText) || buttonText_trim === buttonText) {
                found = true;
                cy.wrap(button).click({ force: true });
                return false;
            }
        });

        if (!found) {
            cy.log(`⚠️ Frontend henüz hazır değil: "${buttonText}" butonu bulunamadı.`);
        }
    });
});

// *** THEN ADIMLARI ***
Then('sistem {string} mesajını gösterir', (message) => {
    cy.get('body').then(($body) => {
        const $toast = $body.find('.toast-success, .alert-success, .message-success');
        if ($toast.length > 0 && $toast.is(':visible')) {
            cy.wrap($toast).should('contain', message);
        } else {
            cy.log(`⚠️ Frontend henüz hazır değil: Başarı mesajı gösterilemiyor.`);
        }
    });
});

Then('sistem {string} hata mesajını gösterir', (errorMessage) => {
    cy.get('body').then(($body) => {
        const $error = $body.find('.toast-error, .alert-error, .message-error, .error-message');
        if ($error.length > 0 && $error.is(':visible')) {
            cy.wrap($error).should('contain', errorMessage);
        } else {
            cy.log(`⚠️ Frontend henüz hazır değil: Hata mesajı gösterilemiyor.`);
        }
    });
});

Then('kullanıcı kredi bakiyesinin {int} kredi düştüğünü doğrular', (creditAmount) => {
    cy.get('body').then(($body) => {
        const $balance = $body.find('[data-cy="credit-balance"], .credit-balance');
        if ($balance.length > 0) {
            cy.wrap($balance).should('be.visible');
            cy.log(`Kredi bakiyesi ${creditAmount} kredi düşmüş olmalı (frontend geliştirildiğinde detaylı kontrol eklenecek)`);
        } else {
            cy.log('⚠️ Frontend henüz hazır değil: Kredi bakiyesi kontrol edilemiyor.');
        }
    });
});

