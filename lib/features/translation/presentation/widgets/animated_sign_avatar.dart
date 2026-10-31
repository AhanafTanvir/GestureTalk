import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// AnimatedSignAvatar renders the animated character that translates
/// speech/text into dynamic visual sign gestures.
class AnimatedSignAvatar extends StatefulWidget {
  final String activeSign;
  final bool isSpeaking;
  final bool isListening;

  const AnimatedSignAvatar({
    super.key,
    required this.activeSign,
    this.isSpeaking = false,
    this.isListening = false,
  });

  @override
  State<AnimatedSignAvatar> createState() => _AnimatedSignAvatarState();
}

class _AnimatedSignAvatarState extends State<AnimatedSignAvatar>
    with TickerProviderStateMixin {
  late AnimationController _idleController;
  late AnimationController _gestureController;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _gestureController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant AnimatedSignAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeSign != widget.activeSign) {
      _gestureController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _idleController.dispose();
    _gestureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Ambient background glow
        AnimatedBuilder(
          animation: _idleController,
          builder: (context, child) {
            final scale = 1.0 + (_idleController.value * 0.08);
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryLight.withOpacity(isDark ? 0.25 : 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // Listening pulse rings when microphone is active
        if (widget.isListening)
          AnimatedBuilder(
            animation: _gestureController,
            builder: (context, child) {
              return Container(
                width: 230 + (_gestureController.value * 25),
                height: 230 + (_gestureController.value * 25),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.secondary.withOpacity(
                        (1.0 - _gestureController.value) * 0.5),
                    width: 2.0,
                  ),
                ),
              );
            },
          ),

        // Avatar Body & Signing Animation
        AnimatedBuilder(
          animation: Listenable.merge([_idleController, _gestureController]),
          builder: (context, child) {
            final headBob = math.sin(_idleController.value * math.pi) * 4.0;
            final armSway = math.sin(_gestureController.value * math.pi) * 16.0;
            final handRotation = (_gestureController.value - 0.5) * 0.35;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Head with face, hair, and expressive eyes
                Transform.translate(
                  offset: Offset(0, -headBob),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Hair & Head Base
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF2C241E), // Dark hair
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      // Face Skin
                      Container(
                        width: 82,
                        height: 82,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFF3CBB3), Color(0xFFE2B49A)],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Eyes
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildEye(widget.isSpeaking),
                                const SizedBox(width: 18),
                                _buildEye(widget.isSpeaking),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Gentle smile / mouth
                            Container(
                              width: widget.isSpeaking ? 16 : 14,
                              height: widget.isSpeaking ? 8 : 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8D4F38),
                                borderRadius: widget.isSpeaking
                                    ? BorderRadius.circular(8)
                                    : const BorderRadius.vertical(
                                        bottom: Radius.circular(6)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Glasses / Brow detail
                      Positioned(
                        top: 36,
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 12,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.brown.shade800, width: 2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 2,
                              color: Colors.brown.shade800,
                            ),
                            Container(
                              width: 24,
                              height: 12,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.brown.shade800, width: 2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // Shirt Torso & Active Signing Arms
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Torso Shirt with buttons (matching Mockup 8)
                    Container(
                      width: 136,
                      height: 74,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF334155) : Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(36),
                          bottom: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          // Shirt collar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Transform.rotate(
                                angle: -0.3,
                                child: Container(
                                  width: 22,
                                  height: 10,
                                  color: isDark
                                      ? const Color(0xFF475569)
                                      : const Color(0xFFE2E8F0),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Transform.rotate(
                                angle: 0.3,
                                child: Container(
                                  width: 22,
                                  height: 10,
                                  color: isDark
                                      ? const Color(0xFF475569)
                                      : const Color(0xFFE2E8F0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // 3 shirt buttons
                          ...List.generate(
                            3,
                            (idx) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 2.5),
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0F172A),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Left Signing Hand
                    Positioned(
                      left: 6 - (armSway * 0.3),
                      top: 14 + (armSway * 0.2),
                      child: Transform.rotate(
                        angle: -handRotation,
                        child: _buildHandGesture(isLeft: true),
                      ),
                    ),

                    // Right Signing Hand
                    Positioned(
                      right: 6 + (armSway * 0.3),
                      top: 14 - (armSway * 0.2),
                      child: Transform.rotate(
                        angle: handRotation,
                        child: _buildHandGesture(isLeft: false),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),

        // Live Active Sign Badge floating near hands
        Positioned(
          top: 18,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.72),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.secondary.withOpacity(0.6),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.sign_language_rounded,
                  size: 14,
                  color: Colors.amberAccent,
                ),
                const SizedBox(width: 6),
                Text(
                  'SIGN: ${widget.activeSign}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Avatar Character Pill Badge (matching Mockup 8)
        Positioned(
          bottom: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              'Avatar character',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEye(bool isBlinking) {
    if (isBlinking) {
      return Container(
        width: 10,
        height: 2,
        color: const Color(0xFF1E293B),
      );
    }
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildHandGesture({required bool isLeft}) {
    return Container(
      width: 28,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFF3CBB3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE2B49A),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          isLeft ? Icons.waving_hand_rounded : Icons.pan_tool_alt_rounded,
          size: 18,
          color: Colors.brown.shade700,
        ),
      ),
    );
  }
}

