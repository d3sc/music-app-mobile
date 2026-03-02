#+ Music App

This is a **simple music player application** built with **Flutter**, featuring authentication, a music collection list, and a full music player with a progress bar and mini player.

## Main Features

- **Authentication**
  - Login with a token stored in `SecureStorage`.
- **Music Collection**
  - Display a list of songs fetched from an API using `Dio`.
  - Each item shows title and artist.
- **Music Player**
  - Uses the `just_audio` package.
  - Supports playlists (`ConcatenatingAudioSource`).
  - Progress bar implemented with `audio_video_progress_bar`.
  - Play / pause, seek, and navigate between tracks in the playlist.
- **Mini Player**
  - Mini player at the bottom of the list showing the currently playing song.
- **State Management**
  - Uses `provider` with `MusicPlayerService` as a `ChangeNotifier`.

## Project Structure (Overview)

Important directories and files:

- `lib/main.dart`  
  Application entry point, initializes `ChangeNotifierProvider<MusicPlayerService>` and `MaterialApp.router`.

- `lib/router.dart`  
  Main routing configuration.

- `lib/domain/music.dart`  
  `Music` domain model (id, title, artist, url, etc.).

- `lib/core/network/dio_client.dart`  
  `Dio` client configuration for backend requests.

- `lib/core/storage/secure_storage.dart`  
  Wrapper for securely storing tokens.

- `lib/features/auth/presentation/login_page.dart`  
  Login screen.

- `lib/features/music/data/music_repository.dart`  
  Repository for fetching music data from the API.

- `lib/features/music/application/music_player_service.dart`  
  Music player service/manager:
  - Manages the `AudioPlayer`.
  - Stores the playlist (`List<Music>`).
  - Exposes position and duration streams.
  - Provides `setPlaylist`, `play`, `pause`, `seek`, etc.

- `lib/features/music/presentation/music_collection_page.dart`  
  Music list/collection screen:
  - Fetches music data via `MusicRepository`.
  - Sets the playlist in `MusicPlayerService`.
  - Tapping an item plays the song and navigates to `MusicPlayerPage`.
  - Uses `MiniPlayer` at the bottom.

- `lib/features/music/presentation/music_page.dart`  
  Main player screen:
  - Shows currently playing song info (`currentMusic` from `MusicPlayerService`).
  - Progress bar and play/pause controls (using `Consumer<MusicPlayerService>`).

- `lib/features/music/presentation/widget/mini_player.dart`  
  Mini player widget shown at the bottom of the screen.

## Running the App

Make sure you have installed:

- Flutter SDK
- Dart SDK
- Android Studio / Xcode (for emulators/simulators)

### 1. Clone / open the project

```bash
git clone <your-repo-url>
cd music_app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the application

```bash
flutter run
```

Choose any available device/emulator.

## Backend and Token Configuration

This app relies on:

- An **API endpoint** configured in `dio_client.dart`.
- An **authentication token** stored via `SecureStorage`.

Make sure:

- The base API URL is correctly configured in `dio_client.dart`.
- The login flow stores the token in `SecureStorage` so that `MusicPlayerService` can use it when calling the music API with the `Authorization: Bearer <token>` header.

## Main Dependencies

Some important packages used (see `pubspec.yaml` for the full list):

- `provider` – state management.
- `dio` – HTTP client.
- `flutter_secure_storage` – secure token storage.
- `just_audio` – audio playback.
- `audio_video_progress_bar` – progress bar widget for audio.

## Development Notes and Tips

- If audio does not play:
  - Check the base API URL and music endpoint.
  - Ensure the token is valid and sent in the headers.
- If the playlist is always empty:
  - Make sure `musicRepository.getAllMusic()` returns a `List<Music>`.
  - Ensure `setPlaylist(musics)` is called before `play()`.

## License

Adjust this section according to the license you prefer, for example:

This project is created for learning/personal purposes. Feel free to modify and use it as needed.

