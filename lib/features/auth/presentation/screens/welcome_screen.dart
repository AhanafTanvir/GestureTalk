import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/gestutalk_logo.dart';
import '../../../../core/widgets/gradient_scaffold.dart';

/// Welcome Screen matching the Figma UI Mockup
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GradientScaffold(
      body: InkWell(
        onTap: () => context.go(AppRoutes.login),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // 1. Stylized "Welcome" in cursive / calligraphic font
              Text(
                'Welcome',
                style: GoogleFonts.dancingScript(
                  textStyle: TextStyle(
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                    fontSize: 66,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 2. "to"
              Text(
                'to',
                style: GoogleFonts.caveat(
                  textStyle: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: isDark
                        ? Colors.white.withOpacity(0.8)
                        : const Color(0xFF1E293B).withOpacity(0.85),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Brand Name "GestuTalk"
              Text(
                'GestuTalk',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 44,
                  letterSpacing: -1.2,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 44),

              // 4. Distinctive GestuTalk Brand Logo
              const GestuTalkLogo(size: 110),

              const Spacer(flex: 3),

              // Bottom proceed prompt
              Padding(
                padding: const EdgeInsets.only(bottom: 28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tap anywhere to start',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
