import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    const ProviderScope(
      child: GestuTalkApp(),
    ),
  );
}

/// Root Application Widget configured with Riverpod, GoRouter & dynamic theming engine
class GestuTalkApp extends ConsumerWidget {
  const GestuTalkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      
      // Dynamic Theming Engine with seamless Light/Dark mode transitions
      themeMode: themeState.themeMode,
      theme: AppTheme.lightTheme(primaryColor: themeState.primaryColor),
      darkTheme: AppTheme.darkTheme(primaryColor: themeState.primaryColor),

      // GoRouter Configuration
      routerConfig: router,
    );
  }
}

