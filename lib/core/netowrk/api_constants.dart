// هذا الكلاس فيه جميع ثوابت الapi

class ApiConstants {
  ApiConstants._();
  static const String baseUrl = 'https://693652bff8dc350aff30780c.mockapi.io/api/v1';
  static const String users = '/users';
  static const String health = '/health';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}