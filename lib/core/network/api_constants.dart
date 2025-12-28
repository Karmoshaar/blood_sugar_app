class ApiConstants {
  ApiConstants._();

  // تأكد من أن الرابط الأساسي ينتهي بـ / أو أن المسارات تبدأ بـ /
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  
  static const String users = '/users';
  
  // ملاحظة: jsonplaceholder لا يحتوي على مسار باسم sugar-readings
  // سنستخدم /posts كمسار بديل للتجربة لتجنب خطأ 404
  static const String sugarReadings = '/posts'; 

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
