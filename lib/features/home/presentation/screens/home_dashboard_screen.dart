import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/widgets/gestutalk_logo.dart';
import '../../../../core/widgets/gestutalk_side_drawer.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../../../core/widgets/user_avatar_circle.dart';

/// Home Dashboard Screen matching Figma mockups (iPhone 15 Pro Portrait Mockup@2x-8 / Frame@2x-4)
/// Features:
/// - Top App Bar: Hamburger icon (left), Circular User Avatar with blue ring (right)
/// - Centered GestuTalk brand logo in upper section
/// - Large circular "Start Talking" centerpiece button
/// - Side Drawer with Home, Allow Access toggles (Camera, Mic), Settings, Logout
class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  void _onStartTalkingPressed(BuildContext context, WidgetRef ref) async {
    // Check or request hardware permissions
    final permState = ref.read(permissionServiceProvider);
    if (!permState.hasAllPermissions) {
      await ref
          .read(permissionServiceProvider.notifier)
          .requestAllHardwarePermissions();
    }

    if (context.mounted) {
      // Show translation mode selection sheet
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Select Translation Mode',
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'GestuTalk offers bidirectional translation modes for inclusive communication.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(ctx)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    child: const Icon(Icons.videocam, color: AppColors.primary),
                  ),
                  title: const Text(
                    'Disabled Person Perspective',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Camera recognizes signs → Speech/Text output',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push(AppRoutes.disabledTranslation);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        AppColors.secondary.withValues(alpha: 0.15),
                    child: const Icon(Icons.record_voice_over,
                        color: AppColors.secondary),
                  ),
                  title: const Text(
                    'Normal Person Perspective',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Microphone listens to speech → Animated 3D Avatar signs',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push(AppRoutes.normalTranslation);
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return GradientScaffold(
      drawer: const GestuTalkSideDrawer(),
      body: Column(
        children: [
          // 1. Top Header Bar matching Figma Mockup 8
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Hamburger Menu Icon
                Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu, size: 30),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
                // Circular User Avatar with Blue Border Ring
                UserAvatarCircle(
                  radius: 20,
                  borderWidth: 2.5,
                  onTap: () => context.push(AppRoutes.editProfile),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. Centered GestuTalk Brand Logo & Text (upper region)
          const GestuTalkLogo(
            size: 42,
            showText: true,
            fontSize: 26,
          ),

          const Spacer(),

          // 3. Centerpiece: Big "Start Talking" Circular Button
          Center(
            child: GestureDetector(
              onTap: () => _onStartTalkingPressed(context, ref),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.38),
                      blurRadius: 40,
                      spreadRadius: 8,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Start\nTalking',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
