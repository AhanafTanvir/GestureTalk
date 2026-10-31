import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/gestutalk_logo.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../../dictionary/presentation/providers/dictionary_provider.dart';
import '../providers/translation_provider.dart';
import '../widgets/animated_sign_avatar.dart';
import '../widgets/translation_history_sheet.dart';

/// Normal Person Perspective Interface matching UI Mockup 8
/// Speech-to-Sign translation using Animated 3D Sign Avatar
class NormalPerspectiveScreen extends ConsumerStatefulWidget {
  const NormalPerspectiveScreen({super.key});

  @override
  ConsumerState<NormalPerspectiveScreen> createState() =>
      _NormalPerspectiveScreenState();
}

class _NormalPerspectiveScreenState
    extends ConsumerState<NormalPerspectiveScreen> {
  final TextEditingController _speechInputController =
      TextEditingController(text: 'Hello, how can I help you?');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(translationProvider.notifier)
          .setPerspective(TranslationPerspective.normal);
    });
  }

  @override
  void dispose() {
    _speechInputController.dispose();
    super.dispose();
  }

  void _translateSpokenSentence(String text, String signToAnimate) {
    _speechInputController.text = text;
    ref.read(translationProvider.notifier).submitSpeechTranslation(
          spokenText: text,
          signAvatarAnimation: signToAnimate,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final txState = ref.watch(translationProvider);
    final dictState = ref.watch(dictionaryProvider);

    return GradientScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: [
              // Top Bar with Back, Logo, and History button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  const GestuTalkLogo(size: 36, showText: true, fontSize: 22),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.history_rounded),
                        tooltip: 'Translation History',
                        onPressed: () => TranslationHistorySheet.show(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.swap_horiz_rounded),
                        tooltip: 'Switch Mode',
                        onPressed: () {
                          context.pushReplacement(
                              AppRoutes.disabledTranslation);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Main Translation Card matching Mockup 8
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header title matching Mockup 8 with gradient text
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                        ).createShader(bounds),
                        child: const Text(
                          'Normal person\nprespective Interface',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Animated 3D Sign Avatar Canvas
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF0F172A)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: AppColors.secondary.withOpacity(0.35),
                              width: 1.5,
                            ),
                          ),
                          child: AnimatedSignAvatar(
                            activeSign: txState.currentAvatarSign,
                            isSpeaking: txState.isPlayingAudio,
                            isListening: txState.isMicActive,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Speech Input Transcript Box (Voice-to-Text conversion)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: txState.isMicActive
                                ? Colors.red.withOpacity(0.5)
                                : Colors.transparent,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              txState.isMicActive
                                  ? Icons.graphic_eq_rounded
                                  : Icons.format_quote_rounded,
                              size: 20,
                              color: txState.isMicActive
                                  ? Colors.red
                                  : AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                txState.isMicActive
                                    ? 'Listening to speech in real time...'
                                    : _speechInputController.text,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: txState.isMicActive
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                  color: txState.isMicActive
                                      ? Colors.red
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (txState.isMicActive)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Quick Phrases / Custom Signs chips for Avatar Playback
                      SizedBox(
                        height: 32,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildPhraseChip(
                              'Hello',
                              'HELLO',
                              'Hello, nice to meet you!',
                            ),
                            _buildPhraseChip(
                              'Thank You',
                              'THANK YOU',
                              'Thank you very much!',
                            ),
                            _buildPhraseChip(
                              'Help',
                              'HELP',
                              'Do you need any help?',
                            ),
                            _buildPhraseChip(
                              'Friend',
                              'FRIEND',
                              'We are friends!',
                            ),
                            ...dictState.signs.map(
                              (s) => _buildPhraseChip(
                                s.label,
                                s.label,
                                'Custom Sign: ${s.label}',
                                isCustom: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Bottom Control Buttons matching Mockup 8: Mic, Speaker, Shuffle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Microphone Button (Captures voice -> signs)
                          IconButton(
                            iconSize: 34,
                            icon: Icon(
                              txState.isMicActive
                                  ? Icons.mic
                                  : Icons.mic_none_rounded,
                              color: txState.isMicActive
                                  ? Colors.red
                                  : theme.colorScheme.onSurface,
                            ),
                            tooltip: 'Voice Input',
                            onPressed: () {
                              ref
                                  .read(translationProvider.notifier)
                                  .toggleMic();
                            },
                          ),

                          // Speaker Button (Audio output)
                          IconButton(
                            iconSize: 34,
                            icon: Icon(
                              txState.isPlayingAudio
                                  ? Icons.volume_up
                                  : Icons.volume_up_outlined,
                              color: txState.isPlayingAudio
                                  ? AppColors.primary
                                  : theme.colorScheme.onSurface,
                            ),
                            tooltip: 'Speak Audio',
                            onPressed: () {
                              ref
                                  .read(translationProvider.notifier)
                                  .playAudioOutput();
                            },
                          ),

                          // Perspective Swap Button (Switches to Disabled Perspective)
                          IconButton(
                            iconSize: 30,
                            icon: const Icon(Icons.shuffle_rounded),
                            tooltip: 'Switch to Disabled Perspective',
                            onPressed: () {
                              context.pushReplacement(
                                  AppRoutes.disabledTranslation);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Language indicator
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Language',
                              style: TextStyle(
                                fontSize: 15,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.65),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              txState.activeLanguage,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhraseChip(String label, String signCode, String fullSentence,
      {bool isCustom = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: ActionChip(
        avatar: Icon(
          isCustom ? Icons.star : Icons.record_voice_over,
          size: 14,
          color: isCustom ? Colors.orange : AppColors.secondary,
        ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isCustom ? Colors.orange : AppColors.secondary,
          ),
        ),
        backgroundColor: (isCustom ? Colors.orange : AppColors.secondary)
            .withOpacity(0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          _translateSpokenSentence(fullSentence, signCode);
        },
      ),
    );
  }
}
