<<<<<<< HEAD
# 💅 Emmi Nail App

Emmi Nail - Firebase destekli güzellik sektörü mobil ve web uygulaması.

## 📖 Proje Hakkında

Bu proje, Emmi Nail markası için müşteri etkileşimini artırmak, randevu yönetimini kolaylaştırmak ve hizmetleri dijital platformda sunmak amacıyla geliştirilmiş tam özellikli bir Flutter uygulamasıdır. Firebase backend entegrasyonu ile real-time veri senkronizasyonu, güvenli kullanıcı yönetimi ve bulut tabanlı dosya depolama sunar.

## 🔥 Firebase Entegrasyonu

Uygulama Google Firebase ile tam entegre edilmiştir:
- **Firebase Authentication** - Güvenli kullanıcı yönetimi
- **Cloud Firestore** - Real-time NoSQL veritabanı
- **Firebase Storage** - Dosya ve resim depolama
- **Firebase Hosting** - Web deployment desteği

## 🚀 Gelişmiş Özellikler

### 🔐 Kullanıcı Yönetimi
- ✅ **Email/Şifre ile Kayıt ve Giriş**
- ✅ **Profil Bilgileri Yönetimi** (Ad, telefon, adres)
- ✅ **Şifre Sıfırlama**
- ✅ **Profil Fotoğrafı Yükleme**
- ✅ **Otomatik Oturum Takibi**
- ✅ **Güvenli Çıkış İşlemi**

### 📅 Randevu Sistemi
- ✅ **Real-time Randevu Alma**
- ✅ **Randevu Durumu Takibi** (Beklemede/Onaylandı/Reddedildi)
- ✅ **Çoklu Şube Desteği** (Berlin, Hamburg, München)
- ✅ **Artist Seçimi**
- ✅ **Tarih ve Saat Seçimi**
- ✅ **Randevu Geçmişi**

### 🎨 Servis Yönetimi
- ✅ **Detaylı Servis Katalogu**
- ✅ **Kategori Bazlı Filtreleme**
- ✅ **Fiyat Bilgileri**
- ✅ **Servis Resimleri ve Galeri**
- ✅ **Real-time Servis Güncellemeleri**

### 📱 Platform Desteği
- ✅ **iOS Uyumlu**
- ✅ **Android Uyumlu** 
- ✅ **Web Uyumlu**
- ✅ **Responsive Tasarım**
- ✅ **Progressive Web App (PWA)**

### 🌍 Çoklu Dil Desteği
- ✅ **Türkçe**
- ✅ **Almanca**
- ✅ **İngilizce**
- ✅ **Dinamik Dil Değiştirme**

## 🛠️ Teknoloji Stack

- **Framework:** Flutter 3.8.1+
- **State Management:** Provider Pattern
- **Backend:** Google Firebase
- **Database:** Cloud Firestore (NoSQL)
- **Authentication:** Firebase Auth
- **Storage:** Firebase Storage
- **Navigation:** Flutter Navigator 2.0
- **UI Framework:** Material Design 3

### 📦 Ana Paketler
```yaml
dependencies:
  firebase_core: ^3.8.0
  firebase_auth: ^5.3.3
  cloud_firestore: ^5.5.0
  firebase_storage: ^12.3.7
  provider: ^6.1.2
  go_router: ^14.7.0
  image_picker: ^1.1.2
  url_launcher: ^6.3.1
```

## � Detaylı Proje Yapısı

```
lib/
├── models/              # Veri modelleri
│   ├── user_model.dart     # Kullanıcı veri modeli
│   ├── appointment_model.dart # Randevu modeli
│   └── service_model.dart     # Servis modeli
├── pages/               # Uygulama sayfaları
│   ├── login_page.dart        # Giriş sayfası
│   ├── registration_page.dart # Kayıt sayfası
│   ├── profile_page.dart      # Profil yönetimi
│   ├── booking_page.dart      # Randevu alma
│   ├── services_page.dart     # Servis katalogu
│   ├── service_detail_page.dart # Servis detayları
│   ├── past_appointments_page.dart # Randevu geçmişi
│   └── nail_album_page.dart   # Nail art galerisi
├── providers/           # State management
│   ├── user_provider.dart        # Kullanıcı durumu
│   ├── appointment_provider.dart # Randevu yönetimi
│   ├── services_provider.dart    # Servis yönetimi
│   └── language_provider.dart    # Dil yönetimi
├── services/            # Backend servisleri
│   ├── auth_service.dart      # Authentication işlemleri
│   ├── database_service.dart  # Firestore işlemleri
│   └── storage_service.dart   # File upload/download
├── widgets/             # Reusable widgets
│   ├── emmi_logo.dart         # Marka logosu
│   ├── emmi_button.dart       # Özel butonlar
│   └── angled_lines_painter.dart # Özel çizimler
├── theme/               # App tema
│   └── app_theme.dart         # Renkler ve stiller
├── firebase_options.dart      # Firebase config
└── main.dart                  # Ana uygulama entry point
```

## 🚀 Kurulum ve Çalıştırma

### Önkoşullar
- Flutter SDK (3.8.1+)
- Dart SDK
- Firebase CLI
- Android Studio / VS Code
- Git

### Adım Adım Kurulum

1. **Flutter SDK'yı yükleyin:**
   - [Flutter resmi sitesinden](https://flutter.dev/docs/get-started/install) indirin
   - PATH'e ekleyin

2. **Projeyi klonlayın:**
   ```bash
   git clone [repository-url]
   cd emmi_nail_app
   ```

3. **Bağımlılıkları yükleyin:**
   ```bash
   flutter pub get
   ```

4. **Firebase kurulumu:**
   ```bash
   # Firebase CLI yükleyin
   npm install -g firebase-tools
   
   # FlutterFire CLI yükleyin
   dart pub global activate flutterfire_cli
   
   # Firebase projesini yapılandırın
   flutterfire configure
   ```

5. **Firebase Console Ayarları:**
   - [Firebase Console](https://console.firebase.google.com/)'da yeni proje oluşturun
   - Authentication, Firestore, Storage servislerini aktifleştirin
   - Security rules'ları ayarlayın

6. **Uygulamayı çalıştırın:**
   ```bash
   flutter run
   ```

## 🔧 Firebase Yapılandırması

### Security Rules

**Firestore Rules:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /appointments/{document} {
      allow read, write: if request.auth != null;
    }
    match /services/{document} {
      allow read: if true;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

**Storage Rules:**
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /profile_pictures/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /nail_arts/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /service_images/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

## 📱 Kullanım Kılavuzu

### Kullanıcı Kayıt/Giriş
1. Ana sayfada "Giriş Yap" veya "Kayıt Ol" seçin
2. Email ve şifre ile hesap oluşturun/giriş yapın
3. Profil bilgilerinizi tamamlayın

### Randevu Alma
1. "Randevu Al" sekmesine gidin
2. Şube, hizmet, tarih, saat ve artist seçin
3. Randevunuzu onaylayın
4. Real-time durum takibi yapın

### Profil Yönetimi
1. Profil sekmesine gidin
2. Kişisel bilgilerinizi güncelleyin
3. Profil fotoğrafınızı yükleyin
4. Dil tercihlerinizi ayarlayın

## 🧪 Test ve Geliştirme

### Test Komutları
```bash
# Unit testler
flutter test

# Widget testler
flutter test test/widget_test.dart

# Integration testler
flutter drive --target=test_driver/app.dart
```

### Build Komutları
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 🎨 Tema ve Tasarım

Uygulama Emmi Nail markasına özel tasarım dili kullanır:

### Renk Paleti
- **Emmi Red:** `#E91E63` - Ana marka rengi
- **Emmi White:** `#FFFFFF` - Arka plan ve text
- **Emmi Black:** `#2C2C2C` - Başlıklar ve vurgular
- **Emmi Grey:** `#757575` - İkincil text ve border

### Tipografi
- **Ana Font:** Silka (özel marka fontu)
- **Fallback:** System default fonts

## 📊 Performans ve Optimizasyon

- ✅ **Lazy Loading** - Sayfa bazlı yükleme
- ✅ **Image Optimization** - Otomatik resim optimizasyonu
- ✅ **Cache Management** - Akıllı önbellekleme
- ✅ **Bundle Splitting** - Platform bazlı bundle'lar
- ✅ **Tree Shaking** - Gereksiz kod eliminasyonu

## 🔄 Versiyon Geçmişi

### v1.0.0 (2025-09-03) - 🎉 İlk Release
- ✅ Firebase tam entegrasyonu
- ✅ Kullanıcı Authentication sistemi
- ✅ Real-time randevu yönetimi
- ✅ Çoklu dil desteği (TR/DE/EN)
- ✅ Responsive web/mobile tasarım
- ✅ Cloud Storage entegrasyonu
- ✅ Push notification altyapısı
- ✅ PWA desteği

## 📞 İletişim ve Destek

- **Website:** [emmi-nail.com](https://emmi-nail.com)
- **Email:** support@emmi-nail.com
- **Developer:** Melih Dinçay
- **GitHub Issues:** Sorunları bildirmek için GitHub Issues kullanın

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

## 🤝 Katkıda Bulunma

1. Repository'yi fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

---

**💅 Emmi Nail App ile güzellik dünyasının dijital deneyimini yaşayın!**

*Bu uygulama modern Flutter teknolojileri ve Firebase backend altyapısı ile geliştirilmiştir.*
=======
# emmi-nail-app
Emmi Nail App, güzellik sektörüne özel olarak tasarlanmış modern bir Flutter  uygulamasıdır.
>>>>>>> ecb23339fc7304c7b7b7ede0573990c854ed5855
