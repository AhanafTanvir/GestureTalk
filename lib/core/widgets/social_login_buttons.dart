import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Authentic Google 4-Color 'G' Logo Painter
class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w * 0.40;
    final strokeWidth = w * 0.20;

    final rect = Rect.fromCircle(center: center, radius: radius);

    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = true;

    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = true;

    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = true;

    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = true;

    // Red arc (top)
    canvas.drawArc(rect, 3.40, 1.45, false, redPaint);

    // Yellow arc (left)
    canvas.drawArc(rect, 2.10, 1.30, false, yellowPaint);

    // Green arc (bottom)
    canvas.drawArc(rect, 0.78, 1.32, false, greenPaint);

    // Blue arc (bottom right)
    canvas.drawArc(rect, 0.0, 0.78, false, bluePaint);

    // Blue horizontal bar
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final barRect = Rect.fromLTWH(
      center.dx - 1,
      center.dy - strokeWidth / 2,
      radius + strokeWidth / 2 + 1,
      strokeWidth,
    );
    canvas.drawRect(barRect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GoogleLogoWidget extends StatelessWidget {
  final double size;
  const GoogleLogoWidget({super.key, this.size = 26});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: GoogleLogoPainter(),
      ),
    );
  }
}

/// SocialLoginButtons renders the 4 social login options matching the Figma UI:
/// 1. Google (Multi-color 'G')
/// 2. Facebook (Blue 'f')
/// 3. Apple (Apple logo)
/// 4. Phone/Device (Mobile outline)
class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGoogleTap;
  final VoidCallback? onFacebookTap;
  final VoidCallback? onAppleTap;
  final VoidCallback? onPhoneTap;

  const SocialLoginButtons({
    super.key,
    this.onGoogleTap,
    this.onFacebookTap,
    this.onAppleTap,
    this.onPhoneTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SocialCard(
          tooltip: 'Sign in with Google',
          onTap: onGoogleTap,
          child: const GoogleLogoWidget(size: 26),
        ),
        _SocialCard(
          tooltip: 'Sign in with Facebook',
          onTap: onFacebookTap,
          child: const Icon(
            Icons.facebook,
            color: Color(0xFF1877F2),
            size: 32,
          ),
        ),
        _SocialCard(
          tooltip: 'Sign in with Apple',
          onTap: onAppleTap,
          child: Icon(
            Icons.apple,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            size: 32,
          ),
        ),
        _SocialCard(
          tooltip: 'Sign in with Phone',
          onTap: onPhoneTap,
          child: Icon(
            Icons.phone_android_rounded,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF94A3B8)
                : const Color(0xFF475569),
            size: 28,
          ),
        ),
      ],
    );
  }
}

class _SocialCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String tooltip;

  const _SocialCard({
    required this.child,
    this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

