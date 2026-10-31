enum TranslationType {
  gestureToSpeech,   // Camera detects gesture -> Text & Audio Speech
  speechToAvatar,    // Microphone captures speech -> 3D Sign Avatar animation
}

/// Clean Architecture Entity representing a translation record
class GestureTranslation {
  final String id;
  final TranslationType type;
  final String rawInput;
  final String translatedOutput;
  final String language;
  final double confidence;
  final DateTime timestamp;
  final bool isAudioAvailable;
  final bool isCustomSign;

  const GestureTranslation({
    required this.id,
    required this.type,
    required this.rawInput,
    required this.translatedOutput,
    required this.language,
    required this.confidence,
    required this.timestamp,
    this.isAudioAvailable = true,
    this.isCustomSign = false,
  });

  bool get isGesture => type == TranslationType.gestureToSpeech;
  bool get isSpeech => type == TranslationType.speechToAvatar;
}
