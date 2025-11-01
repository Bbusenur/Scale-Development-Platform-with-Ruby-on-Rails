# response_collection.feature
Feature: Cevap Toplama İşlevi

  # Not: Frontend hazır olana kadar testler elementleri bulamazsa skip edecek
  Scenario: Kullanıcı anket için cevap gönderebilmeli
    Given kullanıcı bir ankete erişebilir durumdadır
    When kullanıcı ankette soruları cevaplar
    And kullanıcı "Gönder" butonuna tıklar
    Then sistem "Cevap başarıyla kaydedildi" mesajını gösterir
    And kullanıcı kredi bakiyesinin 1 kredi düştüğünü doğrular

  Scenario: Yetersiz kredi durumunda cevap gönderilemez
    Given kullanıcı giriş yapmıştır
    And kullanıcının kredi bakiyesi 0 kredidir
    When kullanıcı bir ankete erişir
    And kullanıcı soruları cevaplar
    And kullanıcı "Gönder" butonuna tıklar
    Then sistem "Yetersiz kredi bakiyesi" hata mesajını gösterir

