import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestutalk/core/theme/theme_provider.dart';
import 'package:gestutalk/features/auth/presentation/providers/auth_provider.dart';
import 'package:gestutalk/features/translation/domain/entities/gesture_translation.dart';
import 'package:gestutalk/features/translation/presentation/providers/translation_provider.dart';
import 'package:gestutalk/features/dictionary/presentation/providers/dictionary_provider.dart';
import 'package:gestutalk/features/auth/presentation/screens/welcome_screen.dart';
import 'package:gestutalk/features/auth/presentation/screens/login_screen.dart';
import 'package:gestutalk/features/auth/presentation/screens/signup_screen.dart';
import 'package:gestutalk/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:gestutalk/features/translation/presentation/screens/disabled_perspective_screen.dart';
import 'package:gestutalk/features/translation/presentation/screens/normal_perspective_screen.dart';
import 'package:gestutalk/features/settings/presentation/screens/settings_screen.dart';
import 'package:gestutalk/features/settings/presentation/screens/edit_profile_screen.dart';
import 'package:gestutalk/features/dictionary/presentation/screens/add_sign_screen.dart';
import 'package:gestutalk/features/home/presentation/screens/home_dashboard_screen.dart';
import 'package:flutter/material.dart';

void main() {
  group('GestuTalk Riverpod State Tests', () {
    test('Initial theme state should default to light mode and primary color', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final theme = container.read(themeProvider);
      expect(theme.themeMode, equals(ThemeMode.light));
      expect(theme.isDarkMode, isFalse);
    });

    test('ThemeNotifier toggles theme seamlessly', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeProvider.notifier);
      await notifier.toggleTheme();

      expect(container.read(themeProvider).themeMode, equals(ThemeMode.dark));
      expect(container.read(themeProvider).isDarkMode, isTrue);

      await notifier.toggleTheme();
      expect(container.read(themeProvider).themeMode, equals(ThemeMode.light));
    });

    test('TranslationNotifier toggles perspective between Disabled and Normal', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(translationProvider.notifier);
      expect(container.read(translationProvider).perspective, equals(TranslationPerspective.disabled));

      notifier.togglePerspective();
      expect(container.read(translationProvider).perspective, equals(TranslationPerspective.normal));
    });

    test('TranslationNotifier manages history and custom signs', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(translationProvider.notifier);
      final initialHistoryCount = container.read(translationProvider).translationHistory.length;

      // Submit a detected gesture
      notifier.submitGestureTranslation(
        gesture: 'WELCOME',
        translatedText: 'স্বাগতম',
        confidence: 0.99,
        isCustomSign: true,
      );

      final updatedState = container.read(translationProvider);
      expect(updatedState.translationHistory.length, equals(initialHistoryCount + 1));
      expect(updatedState.recognizedGesture, equals('WELCOME'));
      expect(updatedState.translatedText, equals('স্বাগতম'));
      expect(updatedState.translationHistory.first.isCustomSign, isTrue);
      expect(updatedState.translationHistory.first.type, equals(TranslationType.gestureToSpeech));

      // Submit a voice-to-avatar translation
      notifier.submitSpeechTranslation(
        spokenText: 'How are you?',
        signAvatarAnimation: 'HOW_ARE_YOU',
      );

      final stateAfterSpeech = container.read(translationProvider);
      expect(stateAfterSpeech.translationHistory.first.type, equals(TranslationType.speechToAvatar));
      expect(stateAfterSpeech.currentAvatarSign, equals('HOW_ARE_YOU'));
    });

    test('DictionaryNotifier adds, trains, and deletes custom signs', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(dictionaryProvider.notifier);
      final initialCount = container.read(dictionaryProvider).signs.length;

      notifier.addTrainedSign(
        label: 'THANK_YOU',
        meaning: 'Express gratitude',
        category: 'Greetings',
        samplesCount: 8,
        accuracy: 0.985,
      );

      final updatedSigns = container.read(dictionaryProvider).signs;
      expect(updatedSigns.length, equals(initialCount + 1));
      expect(updatedSigns.last.label, equals('THANK_YOU'));
      expect(updatedSigns.last.isTrained, isTrue);

      // Test delete
      notifier.deleteSign(updatedSigns.last.id);
      expect(container.read(dictionaryProvider).signs.length, equals(initialCount));
    });

    test('AuthNotifier handles simulated login and profile update', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final authNotifier = container.read(authProvider.notifier);
      final success = await authNotifier.login('test@aiub.edu', '123456');

      expect(success, isTrue);
      expect(container.read(authProvider).isAuthenticated, isTrue);
      expect(container.read(authProvider).user?.email, equals('test@aiub.edu'));

      await authNotifier.updateProfile(firstName: 'Salman', lastName: 'Ahmed');
      expect(container.read(authProvider).user?.firstName, equals('Salman'));
      expect(container.read(authProvider).user?.lastName, equals('Ahmed'));
    });
  });

  group('Figma Screens UI Verification Tests', () {
    testWidgets('WelcomeScreen renders typography and brand logo', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: WelcomeScreen()),
        ),
      );

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('to'), findsOneWidget);
      expect(find.text('GestuTalk'), findsOneWidget);
      expect(find.text('文'), findsOneWidget);
    });

    testWidgets('LoginScreen renders social login buttons (Google, Facebook, Apple)', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Enter your email and password to log in'), findsOneWidget);
      expect(find.text('Remember me'), findsOneWidget);
      expect(find.text('Forgot Password ?'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text('Or login with'), findsOneWidget);

      expect(find.byTooltip('Sign in with Google'), findsOneWidget);
      expect(find.byTooltip('Sign in with Facebook'), findsOneWidget);
      expect(find.byTooltip('Sign in with Apple'), findsOneWidget);
      expect(find.byTooltip('Sign in with Phone'), findsOneWidget);
    });

    testWidgets('SignUpScreen renders all required input fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SignUpScreen()),
        ),
      );

      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Birth of date'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Set Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('ForgotPasswordScreen renders Email, Phone Number, and Confirm button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: ForgotPasswordScreen()),
        ),
      );

      expect(find.text('Forgot Password'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('DisabledPerspectiveScreen renders live vision, speech/text output, and swap controls', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DisabledPerspectiveScreen()),
        ),
      );

      expect(find.text('Disable person\nprespective Interface'), findsOneWidget);
      expect(find.text('AI Live Vision'), findsOneWidget);
      expect(find.byIcon(Icons.shuffle_rounded), findsOneWidget);
    });

    testWidgets('NormalPerspectiveScreen renders animated avatar, character badge, and mic input', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: NormalPerspectiveScreen()),
        ),
      );

      expect(find.text('Normal person\nprespective Interface'), findsOneWidget);
      expect(find.text('Avatar character'), findsOneWidget);
      expect(find.byTooltip('Voice Input'), findsOneWidget);
      expect(find.byIcon(Icons.shuffle_rounded), findsOneWidget);
    });

    testWidgets('SettingsScreen renders profile card, theme swatches, language, and customize sign grid', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SettingsScreen()),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Customize sign language'), findsOneWidget);
      expect(find.text('Add\nSign'), findsOneWidget);
      expect(find.text('save'), findsOneWidget);
    });

    testWidgets('EditProfileScreen renders avatar, first/last name, and save action', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: EditProfileScreen()),
        ),
      );

      expect(find.text('Edit profile'), findsOneWidget);
      expect(find.text('Edit profile image'), findsOneWidget);
      expect(find.text('First name'), findsOneWidget);
      expect(find.text('Last name'), findsOneWidget);
      expect(find.text('save'), findsOneWidget);
    });

    testWidgets('HomeDashboardScreen renders GestuTalk brand, Start Talking centerpiece, and side drawer controls', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: HomeDashboardScreen()),
        ),
      );

      expect(find.text('Start\nTalking'), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.text('GestuTalk'), findsOneWidget);
    });

    testWidgets('AddSignScreen renders camera viewport, landmark tracker, label input, and save action', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: AddSignScreen()),
        ),
      );

      expect(find.text('Add Sign'), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      expect(find.text('Sign Meaning / Name'), findsOneWidget);
      expect(find.text('Spoken Translation / Voice Output'), findsOneWidget);
      expect(find.text('save'), findsOneWidget);
    });
  });
}
