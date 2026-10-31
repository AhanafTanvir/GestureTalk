/// App-wide constants for GestuTalk.
class AppConstants {
  static const String appName = 'GestuTalk';
  static const String appTagline = 'Real-Time Language Translation for Sign Language';
  static const String appVersion = '1.0.0';

  // Supported Languages
  static const String defaultLanguage = 'Bengali';
  static const List<String> supportedLanguages = [
    'Bengali',
    'English',
    'American Sign Language (ASL)',
    'British Sign Language (BSL)',
    'Spanish',
  ];

  // Storage Keys
  static const String themeModeKey = 'gestutalk_theme_mode';
  static const String accentColorKey = 'gestutalk_accent_color';
  static const String languageKey = 'gestutalk_language';
  static const String authUserKey = 'gestutalk_current_user';

  // Hardware Defaults
  static const int cameraFps = 30;
  static const double recognitionThreshold = 0.85;
}

