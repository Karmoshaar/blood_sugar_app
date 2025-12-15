import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/core/network/api_constants.dart';

/// Provider لإنشاء وإدارة Dio instance
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,  // ← تأكد من هذا السطر
      connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Interceptors للطباعة
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🚀 REQUEST: ${options.method} ${options.baseUrl}${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ RESPONSE: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print('❌ ERROR: ${error.message}');
        return handler.next(error);
      },
    ),
  );

  return dio;
});