import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/gesture_translation.dart';

enum TranslationPerspective {
  disabled, // Camera detects gestures -> Text & Speech
  normal,   // Voice/Text input -> 3D Avatar signs
}

class TranslationState {
  final TranslationPerspective perspective;
  final bool isCameraActive;
  final bool isMicActive;
  final bool isProcessing;
  final bool isPlayingAudio;
  final String activeLanguage;
  final String? recognizedGesture;
  final String? translatedText;
  final double confidence;
  final String currentAvatarSign;
  final List<GestureTranslation> translationHistory;

  const TranslationState({
    this.perspective = TranslationPerspective.disabled,
    this.isCameraActive = true,
    this.isMicActive = false,
    this.isProcessing = false,
    this.isPlayingAudio = false,
    this.activeLanguage = 'Bengali',
    this.recognizedGesture,
    this.translatedText,
    this.confidence = 0.96,
    this.currentAvatarSign = 'HELLO',
    this.translationHistory = const [],
  });

  TranslationState copyWith({
    TranslationPerspective? perspective,
    bool? isCameraActive,
    bool? isMicActive,
    bool? isProcessing,
    bool? isPlayingAudio,
    String? activeLanguage,
    String? recognizedGesture,
    String? translatedText,
    double? confidence,
    String? currentAvatarSign,
    List<GestureTranslation>? translationHistory,
  }) {
    return TranslationState(
      perspective: perspective ?? this.perspective,
      isCameraActive: isCameraActive ?? this.isCameraActive,
      isMicActive: isMicActive ?? this.isMicActive,
      isProcessing: isProcessing ?? this.isProcessing,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      activeLanguage: activeLanguage ?? this.activeLanguage,
      recognizedGesture: recognizedGesture ?? this.recognizedGesture,
      translatedText: translatedText ?? this.translatedText,
      confidence: confidence ?? this.confidence,
      currentAvatarSign: currentAvatarSign ?? this.currentAvatarSign,
      translationHistory: translationHistory ?? this.translationHistory,
    );
  }
}

class TranslationNotifier extends StateNotifier<TranslationState> {
  Timer? _simulationTimer;

  TranslationNotifier()
      : super(TranslationState(
          translationHistory: [
            GestureTranslation(
              id: 'tx_init_1',
              type: TranslationType.gestureToSpeech,
              rawInput: 'Hello (Wave)',
              translatedOutput: 'হ্যালো (নমস্কার)',
              language: 'Bengali',
              confidence: 0.98,
              timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
            ),
            GestureTranslation(
              id: 'tx_init_2',
              type: TranslationType.speechToAvatar,
              rawInput: 'How can I assist you?',
              translatedOutput: 'Avatar Signing: HOW + ASSIST + YOU',
              language: 'Bengali',
              confidence: 0.99,
              timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
            ),
          ],
        )) {
    _startSimulatedRecognition();
  }

  /// Switch perspective between Disabled (Sign-to-Voice) and Normal (Voice-to-Avatar)
  void togglePerspective() {
    final next = state.perspective == TranslationPerspective.disabled
        ? TranslationPerspective.normal
        : TranslationPerspective.disabled;
    setPerspective(next);
  }

  void setPerspective(TranslationPerspective perspective) {
    state = state.copyWith(perspective: perspective);
  }

  void setLanguage(String language) {
    state = state.copyWith(activeLanguage: language);
  }

  void toggleCamera() {
    state = state.copyWith(isCameraActive: !state.isCameraActive);
  }

  void toggleMic() {
    final newMicState = !state.isMicActive;
    state = state.copyWith(isMicActive: newMicState);
    if (newMicState) {
      // Simulate speech-to-text recognition after brief delay
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (state.isMicActive) {
          submitSpeechTranslation(
            spokenText: 'আমি আপনাকে সাহায্য করতে পারি?',
            signAvatarAnimation: 'HELP',
          );
        }
      });
    }
  }

  Future<void> playAudioOutput([String? textToSpeak]) async {
    state = state.copyWith(isPlayingAudio: true);
    await Future.delayed(const Duration(milliseconds: 1600));
    state = state.copyWith(isPlayingAudio: false);
  }

  void clearTranslation() {
    state = state.copyWith(
      recognizedGesture: null,
      translatedText: null,
    );
  }

  void clearHistory() {
    state = state.copyWith(translationHistory: const []);
  }

  void deleteHistoryItem(String id) {
    state = state.copyWith(
      translationHistory:
          state.translationHistory.where((item) => item.id != id).toList(),
    );
  }

  /// Submit a detected hand gesture and convert it to speech & text
  void submitGestureTranslation({
    required String gesture,
    required String translatedText,
    double confidence = 0.98,
    bool isCustomSign = false,
  }) {
    final record = GestureTranslation(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      type: TranslationType.gestureToSpeech,
      rawInput: gesture,
      translatedOutput: translatedText,
      language: state.activeLanguage,
      confidence: confidence,
      timestamp: DateTime.now(),
      isCustomSign: isCustomSign,
    );

    state = state.copyWith(
      recognizedGesture: gesture,
      translatedText: translatedText,
      confidence: confidence,
      currentAvatarSign: gesture.toUpperCase().split(' ').first,
      translationHistory: [record, ...state.translationHistory],
    );
  }

  /// Submit voice/speech input and convert it to 3D Avatar sign animation
  void submitSpeechTranslation({
    required String spokenText,
    required String signAvatarAnimation,
    double confidence = 0.99,
  }) {
    final record = GestureTranslation(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      type: TranslationType.speechToAvatar,
      rawInput: spokenText,
      translatedOutput: 'Avatar Signing: ${signAvatarAnimation.toUpperCase()}',
      language: state.activeLanguage,
      confidence: confidence,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      translatedText: spokenText,
      currentAvatarSign: signAvatarAnimation.toUpperCase(),
      confidence: confidence,
      translationHistory: [record, ...state.translationHistory],
    );
  }

  void _startSimulatedRecognition() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (state.perspective == TranslationPerspective.disabled &&
          state.isCameraActive) {
        final samples = [
          {'g': 'Hello (Wave)', 't': 'হ্যালো (নমস্কার)'},
          {'g': 'Thank you', 't': 'আপনাকে ধন্যবাদ'},
          {'g': 'Help needed', 't': 'সাহায্য প্রয়োজন'},
          {'g': 'Yes', 't': 'হ্যাঁ'},
          {'g': 'Friend', 't': 'বন্ধু'},
        ];
        final sample = samples[(DateTime.now().second ~/ 10) % samples.length];
        submitGestureTranslation(
          gesture: sample['g']!,
          translatedText: sample['t']!,
        );
      }
    });
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}

final translationProvider =
    StateNotifierProvider<TranslationNotifier, TranslationState>((ref) {
  return TranslationNotifier();
});
