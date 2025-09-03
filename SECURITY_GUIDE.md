# 🔒 GÜVENLİK KILAVUZU

## API Key'leri ve Hassas Bilgileri Gizleme

Bu proje, Firebase API key'leri ve diğer hassas bilgileri güvenli bir şekilde yönetmek için environment variables sistemi kullanır.

### ⚠️ ÖNEMLİ GÜVENLİK UYARISI

1. **`.env` dosyası asla GitHub'a yüklenmemelidir!**
2. **API key'leri kod içinde hardcode edilmemelidir!**
3. **Firebase config dosyaları `.gitignore`'da olmalıdır!**

### 🔧 Kurulum

1. `.env.example` dosyasını kopyalayın ve `.env` olarak adlandırın:
   ```bash
   cp .env.example .env
   ```

2. `.env` dosyasına gerçek API key'lerinizi ekleyin:
   ```env
   FIREBASE_WEB_API_KEY=your-actual-api-key
   FIREBASE_WEB_APP_ID=your-actual-app-id
   # ... diğer değerler
   ```

3. Firebase Console'dan API key'lerinizi kopyalayın ve `.env` dosyasına yapıştırın.

### 📋 Gerekli Environment Variables

#### Web
- `FIREBASE_WEB_API_KEY`
- `FIREBASE_WEB_APP_ID`
- `FIREBASE_WEB_MESSAGING_SENDER_ID`
- `FIREBASE_WEB_PROJECT_ID`
- `FIREBASE_WEB_AUTH_DOMAIN`
- `FIREBASE_WEB_STORAGE_BUCKET`

#### Android
- `FIREBASE_ANDROID_API_KEY`
- `FIREBASE_ANDROID_APP_ID`

#### iOS
- `FIREBASE_IOS_API_KEY`
- `FIREBASE_IOS_APP_ID`
- `FIREBASE_IOS_BUNDLE_ID`

#### macOS
- `FIREBASE_MACOS_API_KEY`
- `FIREBASE_MACOS_APP_ID`
- `FIREBASE_MACOS_BUNDLE_ID`

### 🚨 Güvenlik Önlemleri

1. **GitHub'da Exposed API Key'ler:**
   - Eğer API key'ler yanlışlıkla GitHub'a yüklendiyse, Firebase Console'dan hemen yenileyin
   - Eski key'leri devre dışı bırakın
   - Yeni key'leri `.env` dosyasına ekleyin

2. **Firebase Security Rules:**
   ```javascript
   // Firestore Rules
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Sadece authenticated kullanıcılar okuyabilir/yazabilir
       match /{document=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

3. **Storage Security Rules:**
   ```javascript
   // Storage Rules
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /{allPaths=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

### 🔄 Deploy İşlemi

1. **Local Development:**
   ```bash
   flutter run -d web
   ```

2. **Production Build:**
   ```bash
   flutter build web --release
   ```

3. **Environment Variables Check:**
   - Deploy öncesi tüm environment variables'ların set edildiğinden emin olun
   - Production'da farklı Firebase projesi kullanacaksanız, ayrı `.env.prod` dosyası oluşturun

### 📝 Best Practices

1. **API Key Rotation:** API key'leri düzenli olarak yenileyin
2. **Access Control:** Firebase Console'da IP whitelist kullanın
3. **Monitoring:** Firebase Console'dan API kullanımını takip edin
4. **Backup:** Environment variables'ların güvenli bir backup'ını tutun

### 🆘 Acil Durum

Eğer API key'ler leak olduysa:

1. **Firebase Console → Project Settings → General**
2. **Web apps** bölümünden app'i seçin
3. **Config** kısmından **Regenerate** butonuna tıklayın
4. Yeni config'i `.env` dosyasına güncelleyin
5. Uygulamayı yeniden deploy edin

### 📞 Destek

Güvenlik konularında destek için:
- Firebase Support Center
- Flutter Security Documentation
- GitHub Security Advisories

---
**Son Güncelleme:** 2025-09-03
**Versiyon:** 1.0
