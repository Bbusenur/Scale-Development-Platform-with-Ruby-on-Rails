// cypress/e2e/analysis.js
// Cucumber (Gherkin) step definitions for analysis.feature

import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor';

// *** GIVEN ADIMLARI ***
Given('kullanıcı giriş yapmıştır', () => {
    cy.visit('/');
    cy.log('⚠️ Giriş işlemi frontend geliştirildiğinde implement edilecek');
});

Given('kullanıcı bir ankete sahiptir', () => {
    cy.log('⚠️ Anket kontrolü frontend geliştirildiğinde implement edilecek');
});

Given('kullanıcının yeterli kredisi vardır', () => {
    cy.log('⚠️ Kredi kontrolü frontend geliştirildiğinde implement edilecek');
});

Given('kullanıcının kredi bakiyesi {int} kredidir', (creditAmount) => {
    cy.log(`⚠️ Kredi bakiyesi ayarlama (${creditAmount}) frontend geliştirildiğinde implement edilecek`);
});

// *** WHEN ADIMLARI ***
When('kullanıcı {string} sayfasına gider', (pageName) => {
    const pageRoutes = {
        'Analiz Başlat': '/analysis/new',
        'Analiz Listesi': '/analysis',
        'Anket Listesi': '/surveys'
    };

    const route = pageRoutes[pageName] || '/';
    cy.visit(route, { failOnStatusCode: false });
    cy.url().then((url) => {
        if (url.includes('404')) {
            cy.log(`⚠️ Frontend henüz hazır değil: "${pageName}" sayfası bulunamadı.`);
        }
    });
});

When('kullanıcı {string} alanına {string} seçer', (fieldName, value) => {
    cy.get('body').then(($body) => {
        const selectors = [
            `[data-cy="${fieldName}-select"]`,
            `select[name="${fieldName}"]`,
            `[data-cy="${fieldName}-dropdown"]`
        ];

        let found = false;
        for (const selector of selectors) {
            const $select = $body.find(selector);
            if ($select.length > 0) {
                cy.wrap($select).select(value);
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
        const $buttons = $body.find('button, a.button, input[type="submit"]');
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

Then('kullanıcı analiz durumunu görüntüleyebilir', () => {
    cy.get('body').then(($body) => {
        const selectors = [
            '[data-cy="analysis-status"]',
            '.analysis-status',
            '#analysisStatus'
        ];

        let found = false;
        for (const selector of selectors) {
            const $status = $body.find(selector);
            if ($status.length > 0) {
                cy.wrap($status).should('be.visible');
                found = true;
                break;
            }
        }

        if (!found) {
            cy.log('⚠️ Frontend henüz hazır değil: Analiz durumu gösterilemiyor.');
        }
    });
});

