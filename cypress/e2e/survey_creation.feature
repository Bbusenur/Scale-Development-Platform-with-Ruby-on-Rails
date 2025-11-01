# survey_creation.feature
Feature: Anket Oluşturma İşlevi

  # Not: Frontend hazır olana kadar testler elementleri bulamazsa skip edecek
  Scenario: Başarılı bir şekilde yeni bir anket oluşturulabilmeli
    Given kullanıcı giriş yapmıştır
    And kullanıcı bir ölçeğe sahiptir
    When kullanıcı "Anket Oluştur" sayfasına gider
    And kullanıcı "Başlık" alanına "Memnuniyet Anketi" yazar
    And kullanıcı "Dağıtım Modu" alanına "Email" yazar
    And kullanıcı "Anket Oluştur" butonuna tıklar
    Then sistem "Anket başarıyla oluşturuldu" mesajını gösterir
    And kullanıcı kredi bakiyesinin düştüğünü doğrular

  Scenario: Yetersiz kredi durumunda anket oluşturulamaz
    Given kullanıcı giriş yapmıştır
    And kullanıcının kredi bakiyesi 5 kredidir
    When kullanıcı "Anket Oluştur" sayfasına gider
    And kullanıcı "Başlık" alanına "Test Anketi" yazar
    And kullanıcı "Anket Oluştur" butonuna tıklar
    Then sistem "Yetersiz kredi bakiyesi" hata mesajını gösterir

