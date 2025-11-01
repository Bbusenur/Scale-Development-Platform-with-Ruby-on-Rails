# scale_creation.feature
Feature: Ölçek Oluşturma İşlevi

  # Not: Frontend hazır olana kadar testler elementleri bulamazsa skip edecek
  Scenario: Başarılı bir şekilde yeni bir ölçek oluşturulabilmeli

    # GIVEN: Ön koşul (Kullanıcının nerede olduğu varsayılır)
    Given kullanıcı anasayfaya gider

    # WHEN: Eylem (Kullanıcının yaptığı işlem)
    When kullanıcı "Yeni Ölçek Oluştur" butonuna tıklar
    And kullanıcı "Ad" alanına "Memnuniyet Ölçeği Test" yazar
    And kullanıcı "Açıklama" alanına "Bu bir Cypress BDD testidir" yazar
    And kullanıcı "Kaydet" butonuna tıklar

    # THEN: Sonuç (Sistemin beklenen sonucu)
    Then sistem "Ölçek başarıyla oluşturuldu" mesajını gösterir
    And kullanıcı "Ölçek Listesi" sayfasına yönlendirilir
