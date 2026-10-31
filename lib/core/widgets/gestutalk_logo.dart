import 'package:flutter/material.dart';

/// Painter for the GestuTalk speech-profile logo bubble
class GestuTalkBubblePainter extends CustomPainter {
  final Color color;

  GestuTalkBubblePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    final path = Path();
    // Rounded speech bubble with left profile beak/tail matching GestuTalk branding
    path.moveTo(w * 0.36, h * 0.08);
    path.quadraticBezierTo(w * 0.68, h * 0.04, w * 0.88, h * 0.22);
    path.quadraticBezierTo(w * 1.00, h * 0.44, w * 0.94, h * 0.72);
    path.quadraticBezierTo(w * 0.86, h * 0.94, w * 0.58, h * 0.96);
    path.quadraticBezierTo(w * 0.36, h * 0.96, w * 0.22, h * 0.90);
    // Lower-left speech tail
    path.quadraticBezierTo(w * 0.06, h * 0.88, w * 0.02, h * 0.74);
    path.quadraticBezierTo(w * 0.12, h * 0.70, w * 0.20, h * 0.65);
    // Left profile nose curve
    path.quadraticBezierTo(w * 0.02, h * 0.52, w * 0.06, h * 0.38);
    path.quadraticBezierTo(w * 0.10, h * 0.24, w * 0.20, h * 0.16);
    path.quadraticBezierTo(w * 0.26, h * 0.09, w * 0.36, h * 0.08);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant GestuTalkBubblePainter oldDelegate) =>
      oldDelegate.color != color;
}

/// GestuTalkLogo renders the official brand logo with the speech-profile bubble icon,
/// the eye dot, the white '文' character, and optional stylized typography.
class GestuTalkLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? color;
  final double fontSize;

  const GestuTalkLogo({
    super.key,
    this.size = 56,
    this.showText = false,
    this.color,
    this.fontSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoColor = color ?? theme.colorScheme.primary;

    final logoIcon = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: logoColor.withOpacity(0.35),
            blurRadius: size * 0.25,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: GestuTalkBubblePainter(color: logoColor),
          ),
          // Face Eye dot on left
          Positioned(
            left: size * 0.24,
            top: size * 0.34,
            child: Container(
              width: size * 0.09,
              height: size * 0.09,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Character '文' on right
          Positioned(
            right: size * 0.14,
            top: size * 0.20,
            bottom: size * 0.16,
            child: Center(
              child: Text(
                '文',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.44,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (!showText) {
      return logoIcon;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logoIcon,
        const SizedBox(width: 12),
        Text(
          'GestuTalk',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: theme.colorScheme.onSurface,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
