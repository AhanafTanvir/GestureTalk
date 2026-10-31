# GestureTalk (GestuTalk)
**Real-Time Language Translation for Sign Language**

GestuTalk is an AI-powered cross-platform mobile application designed to break communication barriers between sign language users and non-signers through bidirectional real-time translation.

---

## 🚀 Key Highlights & Architecture

The project is structured according to **Clean Architecture** principles and uses **Riverpod** for declarative, predictable state management.

### 1. Clean Architecture Organization
```text
lib/
├── core/
│   ├── constants/            # App colors, themes, supported languages, API constants
│   ├── router/               # Declarative go_router configuration & route names
│   ├── services/             # Hardware permission checks (Camera & Microphone)
│   ├── theme/                # Theming engine supporting seamless Light & Dark modes
│   └── widgets/              # Reusable UI widgets (GradientScaffold, GestuTalkLogo, Buttons)
├── features/
│   ├── auth/                 # Authentication (Login, Sign Up, Forgot Password)
│   │   ├── domain/           # User entities and repository contracts
│   │   ├── data/             # Models and repository implementations
│   │   └── presentation/     # Screens & Riverpod auth notifier
│   ├── home/                 # Main Dashboard with "Start Talking" action and Bottom Shell
│   ├── translation/          # Core real-time bidirectional translation engine
│   │   ├── disabled/         # Camera sign recognition -> Voice & Text
│   │   └── normal/           # Voice input -> 3D Avatar sign animation
│   ├── calls/                # Recent calls, history, and contact directory
│   ├── settings/             # Dynamic theming & language switching
│   └── dictionary/           # Custom sign registration & camera capture
└── main.dart                 # Application entry point wrapped with ProviderScope
```

---

## 🔒 Hardware Permissions Configured

GestuTalk requires extensive hardware access for on-device computer vision and speech recognition:

### Android (`android/app/src/main/AndroidManifest.xml`)
- `android.permission.CAMERA`: Live sign language gesture tracking
- `android.permission.RECORD_AUDIO`: Speech capture for voice-to-avatar translation
- `android.permission.MODIFY_AUDIO_SETTINGS`: Low-latency audio processing & TTS
- `android.permission.INTERNET`: Cloud AI model synchronization

### iOS (`ios/Runner/Info.plist`)
- `NSCameraUsageDescription`: Camera access for real-time sign language recognition.
- `NSMicrophoneUsageDescription`: Microphone access to capture speech for sign avatar translation.
- `NSSpeechRecognitionUsageDescription`: Speech recognition for spoken word transcription.
- `NSPhotoLibraryUsageDescription`: Photo library access for profile avatar upload.

---

## 🎨 Theming Engine

GestuTalk features a theming engine supporting:
- **Seamless switching** between Dark Mode (Slate 900 `#0F172A`) and Light Mode (Soft Ambient Gradient `#F6F8FD`).
- Dynamic primary accent color switcher with instant UI adaptation.
- Material 3 specifications with unified typography, rounded cards, and elevated feedback.

---

## 🧭 Navigation & Routes (`go_router`)

- `/`: Welcome / Onboarding Screen
- `/login`: User Login
- `/signup`: User Registration
- `/forgot-password`: Account recovery
- `/home`: Main Dashboard (Shell Route with Bottom Navigation)
- `/calls`: Recent call logs
- `/contacts`: Contacts & community
- `/translation/disabled`: Disabled Person Perspective (Sign-to-Speech)
- `/translation/normal`: Normal Person Perspective (Speech-to-Sign Avatar)
- `/settings`: Settings, theme toggle & dictionary overview
- `/settings/edit-profile`: Profile update
- `/dictionary/add-sign`: Add custom sign with camera frame capture

---

## 🛠️ How to Run

1. Ensure Flutter 3.10+ is installed and on your PATH.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run tests:
   ```bash
   flutter test
   ```
4. Run application:
   ```bash
   flutter run
   ```

