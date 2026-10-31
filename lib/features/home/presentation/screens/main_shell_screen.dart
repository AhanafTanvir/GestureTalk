import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/route_names.dart';

/// MainShellScreen hosts persistent bottom navigation matching GestuTalk Figma mockups
class MainShellScreen extends StatelessWidget {
  final Widget child;

  const MainShellScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.calls)) {
      return 0;
    }
    if (location.startsWith(AppRoutes.home)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.contacts)) {
      return 2;
    }
    return 1;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.calls);
        break;
      case 1:
        context.go(AppRoutes.home);
        break;
      case 2:
        context.go(AppRoutes.contacts);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
              width: 1.0,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 1. Calls / Recent (Phone with arrows)
                _buildNavItem(
                  context,
                  index: 0,
                  isSelected: currentIndex == 0,
                  icon: Icons.phone_forwarded_rounded,
                  label: 'Calls',
                ),
                // 2. Main Talk / Home (Two People)
                _buildNavItem(
                  context,
                  index: 1,
                  isSelected: currentIndex == 1,
                  icon: Icons.people_alt_rounded,
                  label: 'GestuTalk',
                ),
                // 3. Add People (Person with plus)
                _buildNavItem(
                  context,
                  index: 2,
                  isSelected: currentIndex == 2,
                  icon: Icons.person_add_alt_1_rounded,
                  label: 'Add People',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required bool isSelected,
    required IconData icon,
    required String label,
  }) {
    // Cyan color matching Figma design (#38BDF8)
    const cyanColor = Color(0xFF38BDF8);

    return InkWell(
      onTap: () => _onItemTapped(index, context),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? cyanColor : cyanColor.withOpacity(0.45),
            ),
            const SizedBox(height: 4),
            // Active dot indicator matching mockup
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 6 : 0,
              height: 6,
              decoration: const BoxDecoration(
                color: cyanColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
