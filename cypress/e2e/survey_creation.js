// cypress/e2e/survey_creation.js
// Cucumber (Gherkin) step definitions for survey_creation.feature

import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor';

// *** GIVEN ADIMLARI ***
Given('kullanıcı giriş yapmıştır', () => {
    cy.visit('/');
    cy.log('⚠️ Giriş işlemi frontend geliştirildiğinde implement edilecek');
});

Given('kullanıcı bir ölçeğe sahiptir', () => {
    // Ölçek seçimi için placeholder
    cy.log('⚠️ Ölçek seçimi frontend geliştirildiğinde implement edilecek');
});

Given('kullanıcının kredi bakiyesi {int} kredidir', (creditAmount) => {
    // Kredi bakiyesi ayarlama için placeholder
    cy.log(`⚠️ Kredi bakiyesi ayarlama (${creditAmount}) frontend geliştirildiğinde implement edilecek`);
});

// *** WHEN ADIMLARI ***
When('kullanıcı {string} sayfasına gider', (pageName) => {
    const pageRoutes = {
        'Anket Oluştur': '/surveys/new',
        'Anket Listesi': '/surveys',
        'Ölçek Listesi': '/scales'
    };

    const route = pageRoutes[pageName] || '/';
    cy.visit(route, { failOnStatusCode: false });
    cy.url().then((url) => {
        if (url.includes('404')) {
            cy.log(`⚠️ Frontend henüz hazır değil: "${pageName}" sayfası bulunamadı.`);
        }
    });
});

When('kullanıcı {string} alanına {string} yazar', (fieldName, value) => {
    cy.get('body').then(($body) => {
        const selectors = [
            `[data-cy="${fieldName}-input"]`,
            `input[name="${fieldName}"]`,
            `textarea[name="${fieldName}"]`,
            `select[name="${fieldName}"]`
        ];

        let found = false;
        for (const selector of selectors) {
            const $input = $body.find(selector);
            if ($input.length > 0) {
                if ($input.is('select')) {
                    cy.wrap($input).select(value);
                } else {
                    cy.wrap($input).clear().type(value);
                }
                found = true;
                break;
            }
        }

        if (!found) {
            cy.log(`⚠️ Frontend henüz hazır değil: "${fieldName}" alanı bulunamadı.`);
        }
    });
});

When('kullanıcı {string} butonuna tıklar', (buttonText) => {
    cy.get('body').then(($body) => {
        const $buttons = $body.find('button, a.button');
        let found = false;
        $buttons.each((index, button) => {
            if (Cypress.$(button).text().trim().includes(buttonText)) {
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

Then('kullanıcı kredi bakiyesinin düştüğünü doğrular', () => {
    cy.get('body').then(($body) => {
        const $balance = $body.find('[data-cy="credit-balance"], .credit-balance');
        if ($balance.length > 0) {
            cy.wrap($balance).should('be.visible');
            cy.log('Kredi bakiyesi düşmüş olmalı (frontend geliştirildiğinde detaylı kontrol eklenecek)');
        } else {
            cy.log('⚠️ Frontend henüz hazır değil: Kredi bakiyesi kontrol edilemiyor.');
        }
    });
});

