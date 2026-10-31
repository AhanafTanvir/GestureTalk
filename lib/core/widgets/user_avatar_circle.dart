import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Reusable User Avatar Circle matching the Figma mockups
/// Features circular border ring in bright blue, soft shadow, and user portrait photo
class UserAvatarCircle extends StatelessWidget {
  final double radius;
  final double borderWidth;
  final Color borderColor;
  final bool hasShadow;
  final VoidCallback? onTap;

  const UserAvatarCircle({
    super.key,
    this.radius = 22,
    this.borderWidth = 2.5,
    this.borderColor = AppColors.primary,
    this.hasShadow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatarWidget = Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: borderColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/user_avatar.png',
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, stack) => Container(
            color: const Color(0xFFE2E8F0),
            child: Icon(
              Icons.person,
              size: radius * 1.1,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatarWidget,
      );
    }
    return avatarWidget;
  }
}

