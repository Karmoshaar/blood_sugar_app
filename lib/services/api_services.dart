import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/core/network/api_constants.dart';
import 'package:blood_sugar_app_1/core/providers/dio_provider.dart';
import 'package:blood_sugar_app_1/models/sugar_reading_model.dart';
import 'package:blood_sugar_app_1/models/user_model.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<List<SugarReading>> getSugarReadings() async {
    try {
      final response = await _dio.get(ApiConstants.sugarReadings);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => SugarReading.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> postSugarReading(SugarReading reading) async {
    try {
      await _dio.post(
        ApiConstants.sugarReadings,
        data: reading.toJson(),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await _dio.post(
        ApiConstants.users,
        data: user.toJson(),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    print('❌ URL: ${error.requestOptions.uri}');
    print('❌ Status Code: ${error.response?.statusCode}');
    print('❌ Data: ${error.response?.data}');

    if (error.type == DioExceptionType.badResponse) {
      if (error.response?.statusCode == 404) {
        return Exception('Error 404: The endpoint "${error.requestOptions.path}" was not found on the server.');
      }
    }
    return Exception('Network Error: ${error.message}');
  }
}
