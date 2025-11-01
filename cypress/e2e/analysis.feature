# analysis.feature
Feature: Analiz İşlevi

  # Not: Frontend hazır olana kadar testler elementleri bulamazsa skip edecek
  Scenario: Kullanıcı anket için analiz başlatabilmeli
    Given kullanıcı giriş yapmıştır
    And kullanıcı bir ankete sahiptir
    And kullanıcının yeterli kredisi vardır
    When kullanıcı "Analiz Başlat" sayfasına gider
    And kullanıcı "Analiz Tipi" alanına "Statistical" seçer
    And kullanıcı "Analiz Başlat" butonuna tıklar
    Then sistem "Analiz başarıyla başlatıldı" mesajını gösterir
    And kullanıcı analiz durumunu görüntüleyebilir

  Scenario: Yetersiz kredi durumunda analiz başlatılamaz
    Given kullanıcı giriş yapmıştır
    And kullanıcının kredi bakiyesi 5 kredidir
    When kullanıcı "Analiz Başlat" sayfasına gider
    And kullanıcı "Analiz Başlat" butonuna tıklar
    Then sistem "Yetersiz kredi bakiyesi" hata mesajını gösterir

