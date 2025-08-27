class ApiEndpoints {
  // Auth endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  
  // Client endpoints
  static const String clients = '/clients';
  static const String clientDetails = '/clients/{id}';
  static const String createClient = '/clients';
  static const String updateClient = '/clients/{id}';
  
  // Product endpoints
  static const String products = '/products';
  static const String productDetails = '/products/{id}';
  
  // Order endpoints
  static const String orders = '/orders';
  static const String orderDetails = '/orders/{id}';
  static const String createOrder = '/orders';
  static const String updateOrder = '/orders/{id}';
  
  // Report endpoints
  static const String reports = '/reports';
  static const String salesReport = '/reports/sales';
  static const String performanceReport = '/reports/performance';
  
  // Profile endpoints
  static const String profile = '/profile';
  static const String updateProfile = '/profile';
  static const String changePassword = '/profile/password';
}
