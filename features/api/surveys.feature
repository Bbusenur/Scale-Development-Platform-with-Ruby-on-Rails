# language: tr
Özellik: Anketler API'si
  API tüketicisi olarak mevcut anketleri listelemek istiyorum.

  Senaryo: Anketleri listeleme boş dizi döndürür
    Diyelim ki sistemde hiç anket yok
    Eğer "/api/v1/surveys" adresine GET isteği gönderirsem
    O zaman yanıt durumu 200 olmalı
    Ve yanıt JSON olarak boş dizi olmalı


