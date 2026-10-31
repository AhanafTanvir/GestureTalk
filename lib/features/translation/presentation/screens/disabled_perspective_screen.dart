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
import '../widgets/camera_hand_tracking_overlay.dart';
import '../widgets/translation_history_sheet.dart';

/// Disabled Person Perspective Interface matching UI Mockup 7
/// Real-time Sign Language detection via Camera to Text & Voice
class DisabledPerspectiveScreen extends ConsumerStatefulWidget {
  const DisabledPerspectiveScreen({super.key});

  @override
  ConsumerState<DisabledPerspectiveScreen> createState() =>
      _DisabledPerspectiveScreenState();
}

class _DisabledPerspectiveScreenState
    extends ConsumerState<DisabledPerspectiveScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(translationProvider.notifier)
          .setPerspective(TranslationPerspective.disabled);
    });
  }

  void _saveCurrentGestureAsCustomSign(String gesture) {
    ref.read(dictionaryProvider.notifier).addSign(gesture);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved "$gesture" to Custom Sign Dictionary!'),
        backgroundColor: AppColors.primary,
      ),
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
                        icon: const Icon(Icons.refresh_rounded),
                        tooltip: 'Clear Output',
                        onPressed: () {
                          ref
                              .read(translationProvider.notifier)
                              .clearTranslation();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Main Translation Card matching Mockup 7
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
                      // Header title matching Mockup 7 with gradient text
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFFEC4899)],
                        ).createShader(bounds),
                        child: const Text(
                          'Disable person\nprespective Interface',
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

                      // Camera / AI Gesture Viewfinder
                      Expanded(
                        child: Stack(
                          children: [
                            // Live hand tracking viewfinder
                            CameraHandTrackingOverlay(
                              isCameraActive: txState.isCameraActive,
                              recognizedGesture: txState.recognizedGesture,
                              confidence: txState.confidence,
                            ),

                            // Camera on/off toggle button at bottom-left of viewfinder
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: FloatingActionButton.small(
                                heroTag: 'camera_toggle',
                                backgroundColor: txState.isCameraActive
                                    ? AppColors.primary
                                    : Colors.grey.shade700,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                onPressed: () {
                                  ref
                                      .read(translationProvider.notifier)
                                      .toggleCamera();
                                },
                                child: Icon(
                                  txState.isCameraActive
                                      ? Icons.videocam
                                      : Icons.videocam_off,
                                  size: 18,
                                ),
                              ),
                            ),

                            // Converted Output Result Card (Speech + Text)
                            if (txState.translatedText != null)
                              Positioned(
                                bottom: 12,
                                left: 60,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF1E293B)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.12),
                                        blurRadius: 10,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Sign: ${txState.recognizedGesture ?? "Gesture"}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 1),
                                                decoration: BoxDecoration(
                                                  color: Colors.green
                                                      .withOpacity(0.12),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  '${(txState.confidence * 100).toInt()}% match',
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              GestureDetector(
                                                onTap: () {
                                                  if (txState.recognizedGesture !=
                                                      null) {
                                                    _saveCurrentGestureAsCustomSign(
                                                        txState
                                                            .recognizedGesture!);
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons.bookmark_add_outlined,
                                                  size: 16,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              txState.translatedText!,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints:
                                                const BoxConstraints(),
                                            icon: Icon(
                                              txState.isPlayingAudio
                                                  ? Icons.volume_up
                                                  : Icons.volume_up_outlined,
                                              color: AppColors.primary,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              ref
                                                  .read(translationProvider
                                                      .notifier)
                                                  .playAudioOutput();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Quick Gesture Test Chips (Including Custom Signs from Dictionary)
                      SizedBox(
                        height: 32,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildQuickSignChip('HELLO', 'হ্যালো'),
                            _buildQuickSignChip('THANK YOU', 'ধন্যবাদ'),
                            _buildQuickSignChip('HELP', 'সাহায্য'),
                            _buildQuickSignChip('YES', 'হ্যাঁ'),
                            ...dictState.signs.map(
                              (s) => _buildQuickSignChip(
                                s.label,
                                s.label,
                                isCustom: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Bottom Controls matching Mockup 7: Mic, Speaker, Swap
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Microphone button
                          IconButton(
                            iconSize: 32,
                            icon: Icon(
                              txState.isMicActive
                                  ? Icons.mic
                                  : Icons.mic_none_rounded,
                              color: txState.isMicActive
                                  ? Colors.red
                                  : theme.colorScheme.onSurface,
                            ),
                            onPressed: () {
                              ref
                                  .read(translationProvider.notifier)
                                  .toggleMic();
                            },
                          ),

                          // Text-to-Speech Output button
                          IconButton(
                            iconSize: 32,
                            icon: Icon(
                              txState.isPlayingAudio
                                  ? Icons.volume_up
                                  : Icons.volume_up_outlined,
                              color: txState.isPlayingAudio
                                  ? AppColors.primary
                                  : theme.colorScheme.onSurface,
                            ),
                            onPressed: () {
                              ref
                                  .read(translationProvider.notifier)
                                  .playAudioOutput();
                            },
                          ),

                          // Perspective Swap button (switches to Normal Perspective)
                          IconButton(
                            iconSize: 30,
                            icon: const Icon(Icons.shuffle_rounded),
                            tooltip: 'Switch to Normal Perspective',
                            onPressed: () {
                              context.pushReplacement(
                                  AppRoutes.normalTranslation);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Language Indicator / Selector: "Language Bengali"
                      InkWell(
                        onTap: () => _showLanguageSelector(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
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
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
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

  Widget _buildQuickSignChip(String sign, String translated,
      {bool isCustom = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: ActionChip(
        avatar: Icon(
          isCustom ? Icons.star : Icons.touch_app_rounded,
          size: 14,
          color: isCustom ? Colors.orange : AppColors.primary,
        ),
        label: Text(
          sign,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isCustom ? Colors.orange : AppColors.primary,
          ),
        ),
        backgroundColor: (isCustom ? Colors.orange : AppColors.primary)
            .withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          ref.read(translationProvider.notifier).submitGestureTranslation(
                gesture: sign,
                translatedText: translated,
                isCustomSign: isCustom,
              );
        },
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...AppConstants.supportedLanguages.map(
            (lang) => ListTile(
              title: Text(lang),
              trailing: ref.watch(translationProvider).activeLanguage == lang
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                ref.read(translationProvider.notifier).setLanguage(lang);
                Navigator.pop(ctx);
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
