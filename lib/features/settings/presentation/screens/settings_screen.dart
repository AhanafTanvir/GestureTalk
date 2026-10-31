import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/gestutalk_logo.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../dictionary/presentation/providers/dictionary_provider.dart';
import '../../../translation/presentation/providers/translation_provider.dart';

/// Settings Screen matching Figma Mockup (iPhone 15 Pro Portrait Mockup@2x-2.png)
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showSignDetails(BuildContext context, WidgetRef ref, CustomSign sign) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.sign_language_rounded,
                color: AppColors.primary, size: 24),
            const SizedBox(width: 8),
            Text(sign.label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meaning: ${sign.meaning ?? "Custom sign"}',
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 6),
            Text('Category: ${sign.category}',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 6),
            Text('Trained Accuracy: ${(sign.accuracy * 100).toInt()}%',
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.green,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text('Samples Trained: ${sign.samplesCount} frames',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(dictionaryProvider.notifier).deleteSign(sign.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Removed "${sign.label}" from dictionary.')),
              );
            },
            child: const Text('Delete Sign',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeState = ref.watch(themeProvider);
    final txState = ref.watch(translationProvider);
    final dictState = ref.watch(dictionaryProvider);

    return GradientScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              // Top Bar with Back Arrow and Centered GestuTalk Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  const GestuTalkLogo(size: 38, showText: true, fontSize: 22),
                  const SizedBox(width: 48), // Spacer to balance back button
                ],
              ),
              const SizedBox(height: 16),

              // Settings Container Card matching Figma Mockup 2
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22.0),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title: "Settings" with Gradient Text
                    Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                        ).createShader(bounds),
                        child: const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 1. Theme Header & Dark/Light Switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Theme',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.85),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              themeState.isDarkMode
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              size: 18,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              themeState.isDarkMode ? 'Dark' : 'Light',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Switch(
                              value: themeState.isDarkMode,
                              activeColor: theme.colorScheme.primary,
                              onChanged: (val) {
                                ref.read(themeProvider.notifier).toggleTheme();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Theme Palette Pill Swatches matching Mockup 2
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(Icons.palette_outlined, size: 20),
                          ...AppColors.themeAccents.map((color) {
                            final isSelected =
                                themeState.primaryColor.value == color.value;
                            return GestureDetector(
                              onTap: () {
                                ref
                                    .read(themeProvider.notifier)
                                    .setAccentColor(color);
                              },
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 2.5,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: color.withValues(alpha: 0.6),
                                            blurRadius: 6,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 2. Language Section
                    Text(
                      'Language',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: txState.activeLanguage,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          items: AppConstants.supportedLanguages.map((lang) {
                            return DropdownMenuItem<String>(
                              value: lang,
                              child: Row(
                                children: [
                                  const Icon(Icons.language, size: 18),
                                  const SizedBox(width: 10),
                                  Text(
                                    lang,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (newLang) {
                            if (newLang != null) {
                              ref
                                  .read(translationProvider.notifier)
                                  .setLanguage(newLang);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Customize Sign Language Section matching Mockup 2
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Customize sign language',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.85),
                          ),
                        ),
                        Text(
                          '${dictState.signs.length} signs',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // 2-Row / 3-Column Grid + Tall "+" Add Sign Card
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 2x3 Grid for Signs
                        Expanded(
                          flex: 3,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.95,
                            ),
                            itemCount: dictState.signs.length > 6
                                ? 6
                                : dictState.signs.length,
                            itemBuilder: (ctx, idx) {
                              final sign = dictState.signs[idx];
                              return InkWell(
                                onTap: () =>
                                    _showSignDetails(context, ref, sign),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF0F172A)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          AppColors.primary.withValues(alpha: 0.3),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        sign.label,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Icon(
                                        Icons.sign_language_rounded,
                                        size: 26,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${(sign.accuracy * 100).toInt()}%',
                                        style: const TextStyle(
                                          fontSize: 8,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Tall "+" Add Sign Card matching Mockup 2
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () => context.push(AppRoutes.addSign),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              height: 156,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF0F172A)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: theme.colorScheme.primary,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_rounded,
                                    size: 38,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Add\nSign',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Blue Pill "save" Button placed OUTSIDE the card matching Mockup 2
              PrimaryButton(
                text: 'save',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings saved successfully!'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                  context.pop();
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
