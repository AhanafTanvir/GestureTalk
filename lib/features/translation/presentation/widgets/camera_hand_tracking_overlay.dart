import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Painter that renders AI Computer Vision hand landmarks, skeleton joints,
/// and detection bounding boxes on top of the live camera view.
class HandLandmarksPainter extends CustomPainter {
  final bool isTracking;
  final String? gestureName;
  final double confidence;

  HandLandmarksPainter({
    required this.isTracking,
    this.gestureName,
    this.confidence = 0.96,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isTracking) return;

    final w = size.width;
    final h = size.height;

    final jointPaint = Paint()
      ..color = const Color(0xFF00E676)
      ..style = PaintingStyle.fill;

    final skeletonPaint = Paint()
      ..color = const Color(0xFF00E676).withOpacity(0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final boxPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    final cornerPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    // Hand center coordinates
    final cx = w * 0.52;
    final cy = h * 0.48;

    // Hand bounding box
    final boxRect = Rect.fromCenter(
      center: Offset(cx, cy),
      width: w * 0.55,
      height: h * 0.58,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(boxRect, const Radius.circular(16)),
      boxPaint,
    );

    // High-tech viewfinder corner brackets
    final len = 16.0;
    // Top-left corner
    canvas.drawLine(boxRect.topLeft, boxRect.topLeft + Offset(len, 0), cornerPaint);
    canvas.drawLine(boxRect.topLeft, boxRect.topLeft + Offset(0, len), cornerPaint);
    // Top-right corner
    canvas.drawLine(boxRect.topRight, boxRect.topRight + Offset(-len, 0), cornerPaint);
    canvas.drawLine(boxRect.topRight, boxRect.topRight + Offset(0, len), cornerPaint);
    // Bottom-left corner
    canvas.drawLine(boxRect.bottomLeft, boxRect.bottomLeft + Offset(len, 0), cornerPaint);
    canvas.drawLine(boxRect.bottomLeft, boxRect.bottomLeft + Offset(0, -len), cornerPaint);
    // Bottom-right corner
    canvas.drawLine(boxRect.bottomRight, boxRect.bottomRight + Offset(-len, 0), cornerPaint);
    canvas.drawLine(boxRect.bottomRight, boxRect.bottomRight + Offset(0, -len), cornerPaint);

    // Simulated Hand Skeleton Landmark Points (21 keypoints MediaPipe layout)
    final wrist = Offset(cx, cy + (h * 0.20));
    final thumbBase = Offset(cx - (w * 0.12), cy + (h * 0.10));
    final thumbTip = Offset(cx - (w * 0.18), cy - (h * 0.02));
    final indexTip = Offset(cx - (w * 0.08), cy - (h * 0.18));
    final middleTip = Offset(cx, cy - (h * 0.22));
    final ringTip = Offset(cx + (w * 0.08), cy - (h * 0.18));
    final pinkyTip = Offset(cx + (w * 0.16), cy - (h * 0.10));

    final palmCenter = Offset(cx, cy);

    // Draw skeleton bone connections
    canvas.drawLine(wrist, thumbBase, skeletonPaint);
    canvas.drawLine(thumbBase, thumbTip, skeletonPaint);
    canvas.drawLine(wrist, palmCenter, skeletonPaint);
    canvas.drawLine(palmCenter, indexTip, skeletonPaint);
    canvas.drawLine(palmCenter, middleTip, skeletonPaint);
    canvas.drawLine(palmCenter, ringTip, skeletonPaint);
    canvas.drawLine(palmCenter, pinkyTip, skeletonPaint);

    // Draw landmark joints
    final keypoints = [
      wrist,
      thumbBase,
      thumbTip,
      indexTip,
      middleTip,
      ringTip,
      pinkyTip,
      palmCenter,
    ];
    for (final point in keypoints) {
      canvas.drawCircle(point, 4.0, jointPaint);
      canvas.drawCircle(
        point,
        6.5,
        Paint()
          ..color = const Color(0xFF00E676).withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant HandLandmarksPainter oldDelegate) =>
      oldDelegate.isTracking != isTracking ||
      oldDelegate.gestureName != gestureName ||
      oldDelegate.confidence != confidence;
}

/// Widget hosting the camera preview simulation and hand tracking overlay
class CameraHandTrackingOverlay extends StatelessWidget {
  final bool isCameraActive;
  final String? recognizedGesture;
  final double confidence;

  const CameraHandTrackingOverlay({
    super.key,
    required this.isCameraActive,
    this.recognizedGesture,
    this.confidence = 0.96,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.35),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Silhouette & Viewfinder Base
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 54,
                  backgroundColor: const Color(0xFFE2C9B0),
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.brown.shade400,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 130,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                ),
              ],
            ),

            // AI Hand Landmark Skeleton Canvas Overlay
            if (isCameraActive)
              Positioned.fill(
                child: CustomPaint(
                  painter: HandLandmarksPainter(
                    isTracking: isCameraActive,
                    gestureName: recognizedGesture,
                    confidence: confidence,
                  ),
                ),
              ),

            // AI Status indicator pill at top-right
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCameraActive
                        ? const Color(0xFF00E676)
                        : Colors.grey,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isCameraActive
                            ? const Color(0xFF00E676)
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isCameraActive ? 'AI Live Vision' : 'Camera Paused',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

