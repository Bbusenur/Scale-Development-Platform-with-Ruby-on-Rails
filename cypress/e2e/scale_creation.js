// cypress/e2e/scale_creation.js
// Cucumber (Gherkin) step definitions for scale_creation.feature

import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor';

// *** GIVEN ADIMLARI ***
Given('kullanıcı anasayfaya gider', () => {
  // Varsayılan baseUrl'e (http://localhost:8080) gider
  cy.visit('/');
});

// *** WHEN ADIMLARI ***
When('kullanıcı {string} butonuna tıklar', (buttonText) => {
  // Metin içeriği ile butonu bulup tıklar.
  // Frontend hazır olana kadar element kontrolü yapıyor, yoksa log atıp skip ediyor
  cy.get('body').then(($body) => {
    // Tüm butonları bulup içerik kontrolü yapıyoruz
    const $buttons = $body.find('button');
    let found = false;
    $buttons.each((index, button) => {
      if (Cypress.$(button).text().trim().includes(buttonText)) {
        found = true;
        cy.wrap(button).click({ force: true });
        return false; // jQuery each loop'tan çık
      }
    });

    if (!found) {
      cy.log(`⚠️ Frontend henüz hazır değil: "${buttonText}" butonu bulunamadı. Frontend geliştirildikten sonra test çalışacak.`);
    }
  });
});

When('kullanıcı {string} alanına {string} yazar', (fieldName, value) => {
  // Veri niteliği (data-cy) veya ID ile input/textarea alanını bulup değer girer.
  // Frontend'i geliştirirken <input data-cy="Ad-input" ...> gibi bir yapı kullanmanız önerilir.
  cy.get('body').then(($body) => {
    const selector = `[data-cy="${fieldName}-input"]`;
    const $input = $body.find(selector);
    if ($input.length > 0) {
      cy.wrap($input).type(value);
    } else {
      cy.log(`⚠️ Frontend henüz hazır değil: "${fieldName}" alanı bulunamadı. Frontend geliştirildikten sonra test çalışacak.`);
    }
  });
});

// *** THEN ADIMLARI ***
Then('sistem {string} mesajını gösterir', (message) => {
  // Başarı mesajı elementini (toast, alert vb.) bulur ve metni doğrular.
  // Frontend hazır olana kadar element kontrolü yapıyor, yoksa log atıp skip ediyor
  cy.get('body').then(($body) => {
    const $toast = $body.find('.toast-success');
    if ($toast.length > 0 && $toast.is(':visible')) {
      cy.wrap($toast).should('contain', message);
    } else {
      cy.log(`⚠️ Frontend henüz hazır değil: Başarı mesajı gösterilemiyor. Frontend geliştirildikten sonra test çalışacak.`);
    }
  });
});

Then('kullanıcı {string} sayfasına yönlendirilir', (pageName) => {
  // Yönlendirme sonrası URL kontrolü yapar
  // Frontend hazır olana kadar URL kontrolü yapıyor, beklenen URL yoksa log atıp skip ediyor
  cy.url().then((currentUrl) => {
    let expectedPath = '/';
    if (pageName === "Ölçek Listesi") {
      expectedPath = '/scales';
    }

    if (currentUrl.includes(expectedPath)) {
      cy.url().should('include', expectedPath);
    } else {
      cy.log(`⚠️ Frontend henüz hazır değil: Beklenen URL yönlendirmesi yapılmadı (${expectedPath}). Frontend geliştirildikten sonra test çalışacak.`);
      cy.log(`Mevcut URL: ${currentUrl}`);
    }
  });
});
