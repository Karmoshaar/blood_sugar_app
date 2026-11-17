import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../features/onboarding/presentation/screens/launch_screen.dart';
import '../features/profile/data/profile_repository.dart';
import '../features/profile/presentation/providers/profile_controller.dart';
import '../features/profile/presentation/screens/profile_setup_screen.dart';
import '../features/readings/presentation/screens/dashboard_screen.dart';

class PulseyApp extends ConsumerWidget {
  const PulseyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Pulsey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: _initialScreen(ref),
    );
  }

  /// Picks where the app opens: the dashboard once a profile exists, the
  /// setup flow if it was left half-way, otherwise the onboarding splash.
  Widget _initialScreen(WidgetRef ref) {
    if (ref.read(profileProvider) != null) return const DashboardScreen();
    if (ref.read(profileRepositoryProvider).loadDraft() != null) {
      return const ProfileSetupScreen();
    }
    return const LaunchScreen();
  }
}
