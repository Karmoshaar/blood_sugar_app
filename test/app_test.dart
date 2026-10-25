import 'dart:convert';

import 'package:blood_sugar_app_1/app/app.dart';
import 'package:blood_sugar_app_1/features/onboarding/presentation/screens/intro_screen.dart';
import 'package:blood_sugar_app_1/features/onboarding/presentation/screens/launch_screen.dart';
import 'package:blood_sugar_app_1/features/profile/presentation/screens/profile_setup_screen.dart';
import 'package:blood_sugar_app_1/features/readings/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

Future<void> pumpApp(WidgetTester tester, Map<String, Object> values) async {
  final overrides = await testOverrides(values: values);
  await tester.pumpWidget(
    ProviderScope(overrides: overrides, child: const PulseyApp()),
  );
}

void main() {
  testWidgets('first launch shows the splash, then the intro', (tester) async {
    await pumpApp(tester, {});
    expect(find.byType(LaunchScreen), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(IntroScreen), findsOneWidget);
  });

  testWidgets('an unfinished setup resumes at its saved step', (tester) async {
    await pumpApp(tester, {
      'profile.setup_draft': jsonEncode({'step': 2, 'name': 'Omar'}),
    });

    expect(find.byType(ProfileSetupScreen), findsOneWidget);
    expect(find.text('When is your birthday?'), findsOneWidget);
    expect(find.text('3/6'), findsOneWidget);
  });

  testWidgets('a saved profile opens the dashboard', (tester) async {
    await pumpApp(tester, {
      'profile.user': jsonEncode({
        'name': 'Omar',
        'gender': 'male',
        'birthDate': '1995-01-01T00:00:00.000',
        'weightKg': 80,
        'heightCm': 180,
      }),
    });
    await tester.pump();

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('No data available'), findsOneWidget);
  });

  testWidgets('setup steps move forward and back', (tester) async {
    await pumpApp(tester, {
      'profile.setup_draft': jsonEncode({'step': 0}),
    });

    final continueButton = find.widgetWithText(ElevatedButton, 'Continue');
    expect(tester.widget<ElevatedButton>(continueButton).onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'Omar');
    await tester.pump();
    await tester.tap(continueButton);
    await tester.pumpAndSettle();
    expect(find.text('What is your gender?'), findsOneWidget);
    expect(find.text('2/6'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('What is your name?'), findsOneWidget);
    expect(find.text('Omar'), findsOneWidget);
  });
}
