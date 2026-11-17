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
    await pumpApp(tester, {'profile.user': jsonEncode(_profile)});
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

  testWidgets('a reading can be added, edited, deleted and restored', (
    tester,
  ) async {
    await pumpApp(tester, {'profile.user': jsonEncode(_profile)});
    await tester.pump();

    await tester.tap(find.text('Add Reading'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '120');
    await tester.tap(find.text('Fasting'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // The bar chart renders the new reading.
    expect(find.text('No data available'), findsNothing);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('120 mg/dL'), findsOneWidget);
    expect(find.textContaining('Fasting'), findsOneWidget);

    await tester.tap(find.text('120 mg/dL'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Reading'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '95');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('95 mg/dL'), findsOneWidget);

    await tester.drag(find.text('95 mg/dL'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('95 mg/dL'), findsNothing);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('95 mg/dL'), findsOneWidget);
  });

  testWidgets('readings follow the unit chosen in settings', (tester) async {
    await pumpApp(tester, {
      'profile.user': jsonEncode(_profile),
      'settings.unit': 'mmolL',
      'readings.items': [
        jsonEncode({'id': '1', 'value': 180, 'time': '2026-01-05T09:30:00'}),
      ],
    });
    await tester.pumpAndSettle();

    expect(find.text('Blood sugar (mmol/L)'), findsOneWidget);
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('10.0 mmol/L'), findsOneWidget);
  });
}

const _profile = {
  'name': 'Omar',
  'gender': 'male',
  'birthDate': '1995-01-01T00:00:00.000',
  'weightKg': 80,
  'heightCm': 180,
};
