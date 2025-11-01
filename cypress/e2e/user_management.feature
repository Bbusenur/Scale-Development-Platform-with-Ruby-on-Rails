# user_management.feature
Feature: Kullanıcı Yönetimi

  # Not: Frontend hazır olana kadar testler elementleri bulamazsa skip edecek
  Scenario: Yeni kullanıcı kaydı oluşturulabilmeli
    Given kullanıcı kullanıcı kayıt sayfasına gider
    When kullanıcı "Ad" alanına "Ahmet" yazar
    And kullanıcı "Soyad" alanına "Yılmaz" yazar
    And kullanıcı "Dil" alanına "tr" yazar
    And kullanıcı "Rol" alanına "researcher" yazar
    And kullanıcı "Kaydet" butonuna tıklar
    Then sistem "Kullanıcı başarıyla oluşturuldu" mesajını gösterir
    And kullanıcı kredi bakiyesinin görüntülendiğini doğrular

  Scenario: Kullanıcı kredi bakiyesini görüntüleyebilmeli
    Given kullanıcı giriş yapmıştır
    When kullanıcı "Profil" sayfasına gider
    Then kullanıcı kredi bakiyesinin görüntülendiğini doğrular
    And kredi bakiyesi 0 veya pozitif bir değer gösterir

