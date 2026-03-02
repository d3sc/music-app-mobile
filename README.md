#+ Music App 🎵

Aplikasi **pemutar musik** sederhana berbasis **Flutter**, dengan fitur autentikasi, daftar koleksi lagu, dan pemutar musik dengan progress bar serta mini player.

## ✨ Fitur Utama

- **Autentikasi**
  - Login dengan token yang disimpan di `SecureStorage`.
- **Koleksi Musik**
  - Menampilkan daftar lagu dari API melalui `Dio`.
  - Setiap item lagu punya judul dan artist.
- **Music Player**
  - Menggunakan package `just_audio`.
  - Mendukung playlist (`ConcatenatingAudioSource`).
  - Progress bar menggunakan `audio_video_progress_bar`.
  - Play / pause, seek, dan navigasi antar lagu dari playlist.
- **Mini Player**
  - Mini player di bagian bawah list yang menampilkan lagu yang sedang diputar.
- **State Management**
  - Menggunakan `provider` dengan `MusicPlayerService` sebagai `ChangeNotifier`.

## 🗂️ Struktur Project Singkat

Struktur direktori penting:

- `lib/main.dart`  
  Entry point aplikasi, inisialisasi `ChangeNotifierProvider<MusicPlayerService>` dan `MaterialApp.router`.

- `lib/router.dart`  
  Konfigurasi routing utama aplikasi.

- `lib/domain/music.dart`  
  Model/domain `Music` (id, title, artist, url, dll).

- `lib/core/network/dio_client.dart`  
  Konfigurasi client `Dio` untuk request ke backend.

- `lib/core/storage/secure_storage.dart`  
  Wrapper penyimpanan token menggunakan secure storage.

- `lib/features/auth/presentation/login_page.dart`  
  Halaman login.

- `lib/features/music/data/music_repository.dart`  
  Repository untuk mengambil data musik dari API.

- `lib/features/music/application/music_player_service.dart`  
  Service/manager pemutar musik:
  - Mengelola `AudioPlayer`.
  - Menyimpan playlist (`List<Music>`).
  - Expose stream posisi & durasi.
  - Metode `setPlaylist`, `play`, `pause`, `seek`, dll.

- `lib/features/music/presentation/music_collection_page.dart`  
  Halaman list/koleksi musik:
  - Ambil data musik dari `MusicRepository`.
  - Set playlist ke `MusicPlayerService`.
  - Tapping item akan play lagu dan navigasi ke `MusicPlayerPage`.
  - Menggunakan `MiniPlayer` di bagian bawah.

- `lib/features/music/presentation/music_page.dart`  
  Halaman utama player:
  - Menampilkan info lagu yang sedang diputar (`currentMusic` dari `MusicPlayerService`).
  - Progress bar + kontrol play/pause (pakai `Consumer<MusicPlayerService>`).

- `lib/features/music/presentation/widget/mini_player.dart`  
  Widget mini player yang muncul di bawah layar.

## 🚀 Menjalankan Aplikasi

Pastikan sudah menginstall:

- Flutter SDK
- Dart SDK
- Android Studio / Xcode (untuk emulator)

### 1. Clone / buka project

```bash
git clone <url-repo-anda>
cd music_app
```

### 2. Install dependency

```bash
flutter pub get
```

### 3. Jalankan aplikasi

```bash
flutter run
```

Pilih device/emulator yang tersedia.

## 🔐 Konfigurasi Backend & Token

Aplikasi ini mengandalkan:

- **Endpoint API** yang dikonfigurasi di `dio_client.dart`.
- **Token autentikasi** yang disimpan melalui `SecureStorage`.

Pastikan:

- Base URL API diatur dengan benar di `dio_client.dart`.
- Alur login menyimpan token ke `SecureStorage` sehingga dapat digunakan oleh `MusicPlayerService` saat memanggil API musik dengan header `Authorization: Bearer <token>`.

## 📦 Dependency Utama

Beberapa package penting yang digunakan (lihat lengkap di `pubspec.yaml`):

- `provider` – state management.
- `dio` – HTTP client.
- `flutter_secure_storage` – penyimpanan token yang aman.
- `just_audio` – audio player.
- `audio_video_progress_bar` – komponen progress bar untuk audio.

## 🧪 Pengembangan & Tips

- Jika audio tidak mau play:
  - Cek kembali base URL API dan endpoint musik.
  - Pastikan token valid dan terkirim di header.
- Jika playlist selalu kosong:
  - Pastikan `musicRepository.getAllMusic()` mengembalikan list `Music`.
  - Pastikan `setPlaylist(musics)` dipanggil sebelum `play()`.

## 📄 Lisensi

Sesuaikan bagian ini dengan lisensi yang Anda inginkan, misalnya:

Proyek ini dibuat untuk keperluan belajar/pribadi. Silakan modifikasi dan gunakan sesuai kebutuhan.
