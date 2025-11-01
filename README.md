# Scale Development Platform (SDP) API

**Psikolojik Ölçek Geliştirme ve Veri Toplama Platformu**

Bu platform, araştırmacıların ve akademisyenlerin psikolojik ölçekler oluşturmalarına, anketler dağıtmalarına ve verileri analiz etmelerine olanak sağlar.

## 🚀 Özellikler

- ✅ **Ölçek (Scale) Geliştirme** - Psikolojik ölçekler oluşturma
- ✅ **Anket (Survey) Yönetimi** - Anket oluşturma ve dağıtım
- ✅ **Veri Toplama** - Katılımcı cevaplarını toplama
- ✅ **Veri Analizi** - İstatistiksel analiz yapma
- ✅ **Kredi Sistemi** - Kullanım bazlı ödeme modeli
- ✅ **BDD Testler** - Cypress + Cucumber ile test senaryoları

## 📋 Gereksinimler

- Ruby 3.x
- Rails 8.x
- PostgreSQL
- Node.js 20.x
- npm/yarn

## 🛠️ Kurulum

### 1. Repository'yi klonlayın
```bash
git clone https://github.com/Bbusenur/Scale-Development-Platform-with-Ruby-on-Rails.git
cd Scale-Development-Platform-with-Ruby-on-Rails
```

### 2. Bağımlılıkları yükleyin
```bash
# Ruby bağımlılıkları
bundle install

# Node.js bağımlılıkları
npm install
```

### 3. Veritabanını oluşturun
```bash
rails db:create
rails db:migrate
rails db:seed
```

### 4. Sunucuyu başlatın
```bash
rails server
```

API `http://localhost:3000` adresinde çalışacaktır.

## 🧪 Testler

### BDD Testleri (Cypress + Cucumber)
```bash
# Tüm testleri çalıştır
npm run cypress:run

# Cypress GUI'yi aç
npm run cypress:open
```

### Ruby Testleri
```bash
# Tüm testleri çalıştır
rails test

# Cucumber feature testleri
bundle exec cucumber
```

## 📚 API Dokümantasyonu

### Endpoints

#### Kullanıcılar (Users)
- `GET /api/v1/users` - Tüm kullanıcıları listele
- `GET /api/v1/users/:id` - Kullanıcı detayı
- `POST /api/v1/users` - Yeni kullanıcı oluştur
- `PATCH /api/v1/users/:id` - Kullanıcı güncelle
- `DELETE /api/v1/users/:id` - Kullanıcı sil

#### Ölçekler (Scales)
- `GET /api/v1/scales` - Tüm ölçekleri listele
- `GET /api/v1/scales/:id` - Ölçek detayı
- `POST /api/v1/scales` - Yeni ölçek oluştur (15 kredi)
- `PATCH /api/v1/scales/:id` - Ölçek güncelle
- `DELETE /api/v1/scales/:id` - Ölçek sil

#### Anketler (Surveys)
- `GET /api/v1/surveys` - Tüm anketleri listele
- `GET /api/v1/scales/:scale_id/surveys` - Ölçeğe ait anketler
- `POST /api/v1/scales/:scale_id/surveys` - Yeni anket oluştur (8 kredi)
- `GET /api/v1/surveys/:id` - Anket detayı
- `PATCH /api/v1/surveys/:id` - Anket güncelle
- `DELETE /api/v1/surveys/:id` - Anket sil

#### Cevaplar (Responses)
- `GET /api/v1/surveys/:survey_id/responses` - Anket cevapları
- `POST /api/v1/surveys/:survey_id/responses` - Yeni cevap ekle (1 kredi)
- `GET /api/v1/responses/:id` - Cevap detayı
- `PATCH /api/v1/responses/:id` - Cevap güncelle
- `DELETE /api/v1/responses/:id` - Cevap sil

#### Analiz (Analysis)
- `GET /api/v1/analysis` - Tüm analizleri listele
- `POST /api/v1/analysis` - Yeni analiz başlat (10 kredi)
- `GET /api/v1/analysis/:id` - Analiz detayı

## 💰 Kredi Sistemi

Platform kullanım bazlı kredi sistemi ile çalışır:

| İşlem | Maliyet |
|-------|---------|
| Ölçek Oluşturma | 15 kredi |
| Anket Oluşturma | 8 kredi |
| Cevap Toplama (her cevap) | 1 kredi |
| Analiz | 10 kredi |

Yeni kullanıcılar 50 kredi ile başlar.

## 📖 Dokümantasyon

- [Proje Amacı ve İşlevleri](PROJECT_PURPOSE.md)

## 🧪 Test Senaryoları

### Mevcut BDD Testleri:
1. ✅ **Scale Creation** - Ölçek oluşturma
2. ✅ **User Management** - Kullanıcı yönetimi
3. ✅ **Survey Creation** - Anket oluşturma
4. ✅ **Response Collection** - Cevap toplama
5. ✅ **Analysis** - Veri analizi

Tüm testler frontend olmadan da çalışır (log mesajlarıyla).

## 🏗️ Teknoloji Stack

- **Backend:** Ruby on Rails 8.x
- **Database:** PostgreSQL
- **Testing:** 
  - Cypress (E2E tests)
  - Cucumber (BDD)
  - RSpec (Unit tests)
- **API:** RESTful JSON API

## 📝 Lisans

ISC

## 👥 Katkıda Bulunanlar

- [Bbusenur](https://github.com/Bbusenur)

## 📞 İletişim

Sorularınız için issue açabilirsiniz.
