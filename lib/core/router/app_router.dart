import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/home/presentation/screens/home_dashboard_screen.dart';
import '../../features/home/presentation/screens/main_shell_screen.dart';
import '../../features/calls/presentation/screens/call_history_screen.dart';
import '../../features/calls/presentation/screens/contacts_screen.dart';
import '../../features/translation/presentation/screens/disabled_perspective_screen.dart';
import '../../features/translation/presentation/screens/normal_perspective_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/edit_profile_screen.dart';
import '../../features/dictionary/presentation/screens/add_sign_screen.dart';

/// Global Navigation Key for programmatic navigation
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

/// Riverpod provider for GoRouter configuration
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.welcome,
    debugLogDiagnostics: true,
    routes: [
      // 1. Welcome / Onboarding Screen
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),

      // 2. Authentication Flow
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // 3. Main Persistent Bottom Navigation Shell (Home, Calls, Contacts)
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return MainShellScreen(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeDashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.calls,
            builder: (context, state) => const CallHistoryScreen(),
          ),
          GoRoute(
            path: AppRoutes.contacts,
            builder: (context, state) => const ContactsScreen(),
          ),
        ],
      ),

      // 4. Real-time AI Translation Interfaces
      GoRoute(
        path: AppRoutes.disabledTranslation,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const DisabledPerspectiveScreen(),
      ),
      GoRoute(
        path: AppRoutes.normalTranslation,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const NormalPerspectiveScreen(),
      ),

      // 5. Settings, Profile & Dictionary
      GoRoute(
        path: AppRoutes.settings,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.addSign,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AddSignScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Route Not Found: ${state.uri}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

