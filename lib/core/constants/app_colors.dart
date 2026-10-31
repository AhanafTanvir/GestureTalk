import 'package:flutter/material.dart';

/// AppColors defines the brand color palette and gradients for GestuTalk.
/// Derived from the official GestuTalk design specifications.
class AppColors {
  // Brand Primary & Accent
  static const Color primary = Color(0xFF2563EB); // Vibrant Royal Blue
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);

  static const Color accent = Color(0xFF38BDF8); // Sky blue
  static const Color secondary = Color(0xFF8B5CF6); // Purple accent

  // Light Theme Palette
  static const Color lightBackground = Color(0xFFF6F8FD);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Dark Theme Palette
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B);    // Slate 800
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);

  // State & Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Gradients matching UI mockups
  static const LinearGradient welcomeGradientLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFEEAD9), // Warm peach tone at top
      Color(0xFFE6E8FD), // Soft lilac
      Color(0xFFDDDFFB), // Subtle purple at bottom
    ],
  );

  static const LinearGradient welcomeGradientDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1E1B4B), // Deep Indigo
      Color(0xFF0F172A), // Slate 900
      Color(0xFF0B0F19), // Deepest charcoal
    ],
  );

  static const LinearGradient cardGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEFF6FF),
      Color(0xFFF5F3FF),
    ],
  );

  static const LinearGradient cardGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E293B),
      Color(0xFF0F172A),
    ],
  );

  // Available Theme Accent Swatches shown on Settings screen
  static const List<Color> themeAccents = [
    Color(0xFF2563EB), // Default Blue
    Color(0xFF9333EA), // Purple
    Color(0xFF06B6D4), // Cyan
    Color(0xFF10B981), // Emerald Green
    Color(0xFFF43F5E), // Rose
    Color(0xFFF97316), // Orange
    Color(0xFFD946EF), // Magenta
  ];
}

