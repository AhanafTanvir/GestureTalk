import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../router/route_names.dart';
import '../services/permission_service.dart';
import 'gestutalk_logo.dart';
import 'user_avatar_circle.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// Side Drawer matching Figma mockups (iPhone 15 Pro Portrait Mockup@2x-9 and -10)
/// Features:
/// - GestuTalk Logo at the top
/// - User avatar with blue ring and Name
/// - "Home" with home icon
/// - "Allow Access" expandable section with Camera & Microphone toggle switches
/// - "Settings" with gear icon
/// - "Logout" in red with logout exit icon
class GestuTalkSideDrawer extends ConsumerStatefulWidget {
  const GestuTalkSideDrawer({super.key});

  @override
  ConsumerState<GestuTalkSideDrawer> createState() => _GestuTalkSideDrawerState();
}

class _GestuTalkSideDrawerState extends ConsumerState<GestuTalkSideDrawer> {
  bool _allowAccessExpanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final permState = ref.watch(permissionServiceProvider);
    final user = ref.watch(authProvider).user;

    final displayName = user?.fullName.isNotEmpty == true
        ? user!.fullName
        : 'Name';

    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // 1. GestuTalk Logo & Brand
            const GestuTalkLogo(size: 38, showText: true, fontSize: 22),
            const SizedBox(height: 28),

            // 2. Circular User Avatar with Blue Ring
            UserAvatarCircle(
              radius: 46,
              borderWidth: 3.5,
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.editProfile);
              },
            ),
            const SizedBox(height: 12),

            // User Name
            Text(
              displayName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 32),

            // 3. Navigation Links List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Home
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    title: Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.home_outlined,
                      size: 24,
                      color: Color(0xFF64748B),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.home);
                    },
                  ),

                  // Allow Access (Collapsible / Expandable)
                  Theme(
                    data: theme.copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: _allowAccessExpanded,
                      onExpansionChanged: (expanded) {
                        setState(() => _allowAccessExpanded = expanded);
                      },
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      title: Text(
                        'Allow Access',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color:
                              isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      trailing: Icon(
                        _allowAccessExpanded
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_right_rounded,
                        color: const Color(0xFF64748B),
                        size: 24,
                      ),
                      children: [
                        // Camera Toggle
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 8),
                          child: ListTile(
                            dense: true,
                            leading: const Icon(
                              Icons.videocam_outlined,
                              color: Color(0xFF64748B),
                              size: 22,
                            ),
                            title: const Text(
                              'Camera',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Switch(
                              value: permState.hasCamera,
                              activeColor: AppColors.primary,
                              onChanged: (val) async {
                                if (val) {
                                  await ref
                                      .read(permissionServiceProvider.notifier)
                                      .requestCameraPermission();
                                } else {
                                  await ref
                                      .read(permissionServiceProvider.notifier)
                                      .openSettings();
                                }
                              },
                            ),
                          ),
                        ),

                        // Microphone Toggle
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 8),
                          child: ListTile(
                            dense: true,
                            leading: const Icon(
                              Icons.mic_none_outlined,
                              color: Color(0xFF64748B),
                              size: 22,
                            ),
                            title: const Text(
                              'Microphone',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Switch(
                              value: permState.hasMicrophone,
                              activeColor: AppColors.primary,
                              onChanged: (val) async {
                                if (val) {
                                  await ref
                                      .read(permissionServiceProvider.notifier)
                                      .requestMicrophonePermission();
                                } else {
                                  await ref
                                      .read(permissionServiceProvider.notifier)
                                      .openSettings();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Settings
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    title: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.settings_outlined,
                      size: 24,
                      color: Color(0xFF64748B),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.push(AppRoutes.settings);
                    },
                  ),
                ],
              ),
            ),

            // 4. Logout Button at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFEF4444),
                  ),
                ),
                trailing: const Icon(
                  Icons.logout_rounded,
                  size: 24,
                  color: Color(0xFFEF4444),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    context.go(AppRoutes.login);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

