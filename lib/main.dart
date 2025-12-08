import 'package:flutter/material.dart';
import 'splash_screen/splash_screen_1.dart';
import 'splash_screen/splash_screen.dart';
import 'AccountSetaup/account_setup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'HealthData/sugar_stats.dart';
import 'core/providers/dio_provider.dart';
import 'package:blood_sugar_app_1/services/api_services.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // اختبار Dio
  await testDio();

  // اختبار ApiService
  await testApiService();

  runApp(
    ProviderScope(child: MyApp()),
  );
}

Future<void> testDio() async {
  final container = ProviderContainer();
  final dio = container.read(dioProvider);

  try {
    final response = await dio.get('/users');
    print('✅ Success: ${response.data}');
  } catch (e) {
    print('❌ Error: $e');
  }
}

Future<void> testApiService() async {
  final container = ProviderContainer();
  final apiService = container.read(apiServiceProvider);

  final testUser = UserModel(
    name: 'أحمد التجريبي',
    gender: 'male',
    birthDate: DateTime(1995, 5, 15),
    weight: 70.0,
    height: 175.0,
  );

  try {
    print('🚀 جاري إرسال البيانات...');
    final result = await apiService.createUser(testUser);
    print('✅ نجح! البيانات المرجعة: ${result.toJson()}');
  } catch (e) {
    print('❌ فشل: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => SplashScreen1(),
        '/splashMain': (_) => SplashMain(),
        '/AccountSetup': (_) => AccountSetup(),
        '/SugarStats': (_) => SugarStats(),
      },
    );
  }
}
