# Proje Amacı ve İşlevleri

## 🎯 Sitenin Ana Amacı

**Scale Development Platform (SDP)** - Psikolojik Ölçek Geliştirme ve Veri Toplama Platformu

Bu platform, araştırmacıların ve akademisyenlerin:
- **Psikolojik ölçekler** (anketler, testler) oluşturmalarına
- Bu ölçekleri **anket olarak dağıtmalarına**
- Toplanan **verileri analiz etmelerine**
- Tüm süreci **kredi sistemi** ile yönetmelerine olanak sağlar.

---

## 📊 Ana İşlevler

### 1. **Ölçek (Scale) Geliştirme**
- Araştırmacılar kendi psikolojik ölçeklerini oluşturabilir
- Her ölçek benzersiz bir ID ile tanımlanır
- Ölçekler kullanıcıya aittir (her kullanıcının birden fazla ölçeği olabilir)
- **Maliyet:** 15 kredi

**Kullanım Senaryosu:**
- Bir psikolog "Depresyon Ölçeği" oluşturmak ister
- Platformda ölçeğini oluşturur ve yapılandırır
- Ölçeği daha sonra anket olarak dağıtabilir

---

### 2. **Anket (Survey) Oluşturma ve Dağıtım**
- Oluşturulan ölçekler anket olarak dağıtılabilir
- Anket durumları: **Draft** (Taslak), **Active** (Aktif), **Completed** (Tamamlandı)
- Dağıtım modları: Email, SMS vb. (genişletilebilir)
- **Maliyet:** 8 kredi

**Kullanım Senaryosu:**
- Araştırmacı "Depresyon Ölçeği"ni anket olarak yayınlar
- Katılımcılara Email veya SMS ile gönderilir
- Katılımcılar anketi cevaplayabilir

---

### 3. **Veri Toplama (Response Collection)**
- Katılımcılar anketlere cevap verir
- Her cevap otomatik olarak kalite kontrolünden geçer
- Veriler temizlenir ve saklanır
- **Maliyet:** 1 kredi (her cevap için)

**Kullanım Senaryosu:**
- Bir katılımcı anketi doldurur ve gönderir
- Sistem cevabı otomatik olarak doğrular
- Veri analiz için hazır hale gelir

---

### 4. **Veri Analizi (Analysis)**
- Toplanan anket verileri analiz edilebilir
- Analiz durumları: **Queued** (Kuyrukta), **Running** (Çalışıyor), **Succeeded** (Başarılı), **Failed** (Başarısız)
- Analiz tipleri: Statistical (İstatistiksel), vb.
- **Maliyet:** 10 kredi

**Kullanım Senaryosu:**
- Araştırmacı toplanan cevapları analiz eder
- Sistem istatistiksel analiz yapar
- Sonuçlar raporlanır

---

### 5. **Kredi Sistemi (Credit System)**
- Platform kredi tabanlı çalışır
- Her işlem için belirli bir kredi maliyeti vardır
- Kullanıcılar başlangıçta 50 kredi ile başlar
- Tüm işlemler kayıt altına alınır

**Kredi Maliyetleri:**
| İşlem | Maliyet |
|-------|---------|
| Ölçek Oluşturma | 15 kredi |
| Anket Oluşturma | 8 kredi |
| Cevap Toplama (her cevap) | 1 kredi |
| Analiz | 10 kredi |

**Kullanım Senaryosu:**
- Yeni kullanıcı kaydolur → 50 kredi alır
- Ölçek oluşturur → 15 kredi harcar (35 kredi kalır)
- Anket oluşturur → 8 kredi harcar (27 kredi kalır)
- 10 cevap toplar → 10 kredi harcar (17 kredi kalır)
- Analiz yapar → 10 kredi harcar (7 kredi kalır)

---

## 🔄 İş Akışı (Workflow)

```
1. Kullanıcı Kaydı
   ↓
2. Ölçek Oluşturma (15 kredi)
   ↓
3. Anket Oluşturma (8 kredi)
   ↓
4. Anketi Dağıtma (Email/SMS)
   ↓
5. Katılımcılar Cevaplar (her cevap 1 kredi)
   ↓
6. Veri Analizi (10 kredi)
   ↓
7. Sonuçları Görüntüleme
```

---

## 👥 Hedef Kullanıcılar

### Ana Hedef Kitle:
1. **Psikologlar** - Kendi testlerini oluşturmak isteyen
2. **Akademisyenler** - Araştırma yapan bilim insanları
3. **Araştırmacılar** - Anket çalışmaları yapanlar
4. **Kurumlar** - Büyük ölçekli araştırma yapan organizasyonlar

### Kullanım Örnekleri:
- **Akademik Araştırma:** Üniversite öğrencilerinin stres seviyesini ölçmek
- **Klinik Psikoloji:** Depresyon veya anksiyete ölçekleri uygulamak
- **Pazarlama Araştırması:** Müşteri memnuniyet anketleri
- **Sosyal Bilimler:** Toplumsal tutum ve davranış ölçümleri

---

## 💡 Platformun Özellikleri

### Teknik Özellikler:
- ✅ **RESTful API** - Modern API yapısı
- ✅ **Kredi Sistemi** - Kullanım bazlı ödeme modeli
- ✅ **Veri Doğrulama** - Otomatik kalite kontrolü
- ✅ **Analiz Motoru** - İstatistiksel analiz desteği
- ✅ **Ölçekleme** - Birden fazla ölçek ve anket yönetimi

### İş Özellikleri:
- ✅ **Esnek Yapı** - Farklı ölçek tipleri için uygun
- ✅ **Dağıtım Seçenekleri** - Email, SMS vb. dağıtım modları
- ✅ **Durum Takibi** - Anket ve analiz durumları takibi
- ✅ **İşlem Geçmişi** - Tüm kredi işlemleri kayıt altında

---

## 🎯 Platformun Değer Önerisi

1. **Kolaylık:** Karmaşık araştırma süreçlerini basitleştirir
2. **Otomasyon:** Veri toplama ve analizi otomatikleştirir
3. **Güvenilirlik:** Standardize edilmiş süreçler
4. **Maliyet Etkinliği:** Kredi sistemi ile esnek ödeme
5. **Ölçeklenebilirlik:** Küçük veya büyük araştırmalar için uygun

---

## 📈 Gelecek Geliştirmeler (Potansiyel)

- [ ] AI destekli ölçek doğrulama (AI Validation)
- [ ] Gelişmiş analiz tipleri (faktör analizi, regresyon vb.)
- [ ] Gerçek zamanlı anket takibi
- [ ] Mobil uygulama desteği
- [ ] Çoklu dil desteği
- [ ] Görsel raporlama ve grafikler
- [ ] Toplu veri içe/dışa aktarma
- [ ] Kullanıcı rolleri ve izinleri (admin, araştırmacı, katılımcı)

---

## 🏗️ Mimarı

Platform şu ana bileşenlerden oluşur:

1. **Backend API (Rails)**
   - RESTful API endpoints
   - Veri doğrulama ve iş mantığı
   - Kredi sistemi yönetimi

2. **Frontend (Geliştirilecek)**
   - Kullanıcı arayüzü
   - Ölçek ve anket yönetim ekranları
   - Analiz sonuç görüntüleme

3. **Test Sistemi (Cypress + Cucumber)**
   - BDD (Behavior-Driven Development)
   - Tüm işlevler için test senaryoları

---

## 📝 Özet

**SDP (Scale Development Platform)**, psikolojik ölçek geliştirme, anket dağıtımı ve veri analizi yapmak isteyen araştırmacılar için tasarlanmış bir platformdur. Kredi tabanlı çalışır ve tüm süreçleri otomatikleştirerek araştırmacılara zaman ve maliyet tasarrufu sağlar.

