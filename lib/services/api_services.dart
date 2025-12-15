import 'package:blood_sugar_app_1/core/network/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:blood_sugar_app_1/models/user_model.dart';
import 'package:riverpod/riverpod.dart';
import 'package:blood_sugar_app_1/core/providers/dio_provider.dart';
class ApiServices {
  final Dio _dio;
  ApiServices(this._dio);
  Future<UserModel> createUser(UserModel user) async {
    try {
      final data = user.toJson();

      print('🌐 Base URL: ${_dio.options.baseUrl}');
      print('🌐 Endpoint: ${ApiConstants.users}');
      print('🌐 Full URL: ${_dio.options.baseUrl}${ApiConstants.users}');
      print('📤 البيانات: $data');

      final response = await _dio.post(
        ApiConstants.users,
        data: data,
      );

      print('✅ Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('فشل في إنشاء المستخدم');
      }

    } on DioException catch (e) {
      print('❌ DioException: ${e.type}');
      print('❌ Response: ${e.response?.statusCode}');
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('خطأ غير متوقع: $e');
    }
  }
  /// معالج الأخطاء الخاص بـ Dio
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('انتهت مهلة الاتصال');

      case DioExceptionType.sendTimeout:
        return Exception('انتهت مهلة الإرسال');

      case DioExceptionType.receiveTimeout:
        return Exception('انتهت مهلة الاستقبال');

      case DioExceptionType.badResponse:
        return Exception('رد خاطئ من السيرفر: ${error.response?.statusCode}');

      case DioExceptionType.cancel:
        return Exception('تم إلغاء الطلب');

      default:
        return Exception('خطأ في الاتصال بالإنترنت');
    }
  }

}
final apiServiceProvider=Provider<ApiServices>((ref)
{final dio =ref.watch(dioProvider);
return ApiServices(dio);
});