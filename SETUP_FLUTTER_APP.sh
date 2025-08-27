#!/bin/bash

# KCC Sales Force Flutter App Setup Script
# This script creates the complete project structure with Clean Architecture

echo "🚀 Setting up KCC Sales Force Flutter App..."

# Navigate to the project directory
cd /c/FlutterProjects/kcc_/kcc_sales_force

# Create core directory structure
echo "📁 Creating core directory structure..."
mkdir -p lib/core/constants
mkdir -p lib/core/errors
mkdir -p lib/core/network
mkdir -p lib/core/storage
mkdir -p lib/core/utils
mkdir -p lib/core/widgets
mkdir -p lib/core/di
mkdir -p lib/core/navigation
mkdir -p lib/core/theme
mkdir -p lib/core/localization

# Create features directory structure
echo "📁 Creating features directory structure..."
mkdir -p lib/features/auth/data/models
mkdir -p lib/features/auth/data/datasources
mkdir -p lib/features/auth/data/repositories
mkdir -p lib/features/auth/domain/entities
mkdir -p lib/features/auth/domain/repositories
mkdir -p lib/features/auth/domain/usecases
mkdir -p lib/features/auth/presentation/pages
mkdir -p lib/features/auth/presentation/widgets
mkdir -p lib/features/auth/presentation/providers

mkdir -p lib/features/dashboard/data/models
mkdir -p lib/features/dashboard/data/datasources
mkdir -p lib/features/dashboard/data/repositories
mkdir -p lib/features/dashboard/domain/entities
mkdir -p lib/features/dashboard/domain/repositories
mkdir -p lib/features/dashboard/domain/usecases
mkdir -p lib/features/dashboard/presentation/pages
mkdir -p lib/features/dashboard/presentation/widgets
mkdir -p lib/features/dashboard/presentation/providers

mkdir -p lib/features/clients/data/models
mkdir -p lib/features/clients/data/datasources
mkdir -p lib/features/clients/data/repositories
mkdir -p lib/features/clients/domain/entities
mkdir -p lib/features/clients/domain/repositories
mkdir -p lib/features/clients/domain/usecases
mkdir -p lib/features/clients/presentation/pages
mkdir -p lib/features/clients/presentation/widgets
mkdir -p lib/features/clients/presentation/providers

mkdir -p lib/features/products/data/models
mkdir -p lib/features/products/data/datasources
mkdir -p lib/features/products/data/repositories
mkdir -p lib/features/products/domain/entities
mkdir -p lib/features/products/domain/repositories
mkdir -p lib/features/products/domain/usecases
mkdir -p lib/features/products/presentation/pages
mkdir -p lib/features/products/presentation/widgets
mkdir -p lib/features/products/presentation/providers

mkdir -p lib/features/orders/data/models
mkdir -p lib/features/orders/data/datasources
mkdir -p lib/features/orders/data/repositories
mkdir -p lib/features/orders/domain/entities
mkdir -p lib/features/orders/domain/repositories
mkdir -p lib/features/orders/domain/usecases
mkdir -p lib/features/orders/presentation/pages
mkdir -p lib/features/orders/presentation/widgets
mkdir -p lib/features/orders/presentation/providers

mkdir -p lib/features/reports/data/models
mkdir -p lib/features/reports/data/datasources
mkdir -p lib/features/reports/data/repositories
mkdir -p lib/features/reports/domain/entities
mkdir -p lib/features/reports/domain/repositories
mkdir -p lib/features/reports/domain/usecases
mkdir -p lib/features/reports/presentation/pages
mkdir -p lib/features/reports/presentation/widgets
mkdir -p lib/features/reports/presentation/providers

mkdir -p lib/features/profile/data/models
mkdir -p lib/features/profile/data/datasources
mkdir -p lib/features/profile/data/repositories
mkdir -p lib/features/profile/domain/entities
mkdir -p lib/features/profile/domain/repositories
mkdir -p lib/features/profile/domain/usecases
mkdir -p lib/features/profile/presentation/pages
mkdir -p lib/features/profile/presentation/widgets
mkdir -p lib/features/profile/presentation/providers

# Create assets directory structure
echo "📁 Creating assets directory structure..."
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/translations
mkdir -p assets/fonts

# Create test directory structure
echo "📁 Creating test directory structure..."
mkdir -p test/unit
mkdir -p test/widget
mkdir -p test/integration
mkdir -p test/mocks

# Create core files
echo "📝 Creating core files..."

# App constants
cat > lib/core/constants/app_constants.dart << 'EOF'
class AppConstants {
  static const String appName = 'KCC Sales Force';
  static const String apiBaseUrl = 'https://your-domain.com/api';
  static const Duration tokenExpiry = Duration(hours: 9);
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int pageSize = 20;
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
EOF

# API endpoints
cat > lib/core/constants/api_endpoints.dart << 'EOF'
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
EOF

# App colors
cat > lib/core/constants/app_colors.dart << 'EOF'
import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF1976D2);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF42A5F5);
  
  // Secondary colors
  static const Color secondary = Color(0xFF424242);
  static const Color secondaryDark = Color(0xFF212121);
  static const Color secondaryLight = Color(0xFF616161);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Background colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  
  // Border colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFE0E0E0);
}
EOF

# App theme
cat > lib/core/theme/app_theme.dart << 'EOF'
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}
EOF

# Network client
cat > lib/core/network/api_client.dart << 'EOF'
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class ApiClient {
  late final Dio _dio;
  
  ApiClient() {
    _dio = Dio();
    _setupDio();
  }
  
  void _setupDio() {
    _dio.options.baseUrl = AppConstants.apiBaseUrl;
    _dio.options.connectTimeout = AppConstants.connectionTimeout;
    _dio.options.receiveTimeout = AppConstants.receiveTimeout;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Add interceptors
    _dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
    ]);
  }
  
  Dio get dio => _dio;
}
EOF

# Auth interceptor
cat > lib/core/network/interceptors/auth_interceptor.dart << 'EOF'
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if available
    // final token = AuthService.instance.token;
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle auth errors (401, 403)
    if (err.response?.statusCode == 401) {
      // Handle unauthorized
      // AuthService.instance.logout();
    }
    handler.next(err);
  }
}
EOF

# Logging interceptor
cat > lib/core/network/interceptors/logging_interceptor.dart << 'EOF'
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('🌐 REQUEST[${options.method}] => PATH: ${options.path}');
    handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    handler.next(response);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    handler.next(err);
  }
}
EOF

# Local storage
cat > lib/core/storage/local_storage.dart << 'EOF'
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static const String _boxName = 'kcc_app';
  static late Box _box;
  
  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }
  
  static Future<void> saveToken(String token) async {
    await _box.put('auth_token', token);
  }
  
  static String? getToken() {
    return _box.get('auth_token');
  }
  
  static Future<void> removeToken() async {
    await _box.delete('auth_token');
  }
  
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _box.put('user', user);
  }
  
  static Map<String, dynamic>? getUser() {
    return _box.get('user');
  }
  
  static Future<void> removeUser() async {
    await _box.delete('user');
  }
  
  static Future<void> clearAll() async {
    await _box.clear();
  }
}
EOF

# Error handling
cat > lib/core/errors/failures.dart << 'EOF'
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}
EOF

# Result class
cat > lib/core/errors/result.dart << 'EOF'
import 'failures.dart';

abstract class Result<T> {
  const Result();
  
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  
  T? get data => isSuccess ? (this as Success<T>).data : null;
  Failure? get failure => isFailure ? (this as Failure<T>).failure : null;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final Failure failure;
  const Failure(this.failure);
}
EOF

# Main app file
cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/storage/local_storage.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage
  await LocalStorage.init();
  
  runApp(
    const ProviderScope(
      child: KCCApp(),
    ),
  );
}
EOF

# App widget
cat > lib/app.dart << 'EOF'
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';

class KCCApp extends StatelessWidget {
  const KCCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'KCC Sales Force',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
EOF

# App router
cat > lib/core/navigation/app_router.dart << 'EOF'
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
    ],
  );
}
EOF

# Update pubspec.yaml
echo "📝 Updating pubspec.yaml..."
cp ../kcc_api/FLUTTER_PUBSPEC_YAML_COMPLETE.yaml pubspec.yaml

# Create placeholder files for features
echo "📝 Creating placeholder files for features..."

# Auth feature
cat > lib/features/auth/domain/entities/user.dart << 'EOF'
class User {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final String? profileImage;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.profileImage,
  });
}
EOF

cat > lib/features/auth/presentation/pages/login_page.dart << 'EOF'
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: const Center(
        child: Text('Login Page'),
      ),
    );
  }
}
EOF

# Dashboard feature
cat > lib/features/dashboard/presentation/pages/dashboard_page.dart << 'EOF'
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: const Center(
        child: Text('Dashboard Page'),
      ),
    );
  }
}
EOF

# Create README
cat > README.md << 'EOF'
# KCC Sales Force

A Flutter application for sales force automation built with Clean Architecture.

## Features

- Authentication & Authorization
- Client Management
- Product Catalog
- Order Management
- Sales Reports
- User Profile Management

## Architecture

This project follows Clean Architecture principles with the following layers:

- **Presentation Layer**: UI components, pages, and state management
- **Domain Layer**: Business logic, entities, and use cases
- **Data Layer**: Data sources, repositories, and models

## Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

- **State Management**: Riverpod
- **Navigation**: GoRouter
- **HTTP Client**: Dio + Retrofit
- **Local Storage**: Hive
- **UI Components**: Material 3

## Project Structure

```
lib/
├── core/                 # Core functionality
│   ├── constants/       # App constants
│   ├── errors/          # Error handling
│   ├── network/         # Network configuration
│   ├── storage/         # Local storage
│   ├── theme/           # App theme
│   └── navigation/      # Navigation setup
├── features/            # Feature modules
│   ├── auth/           # Authentication
│   ├── dashboard/      # Dashboard
│   ├── clients/        # Client management
│   ├── products/       # Product catalog
│   ├── orders/         # Order management
│   ├── reports/        # Sales reports
│   └── profile/        # User profile
└── main.dart           # App entry point
```
EOF

echo "✅ Flutter app structure created successfully!"
echo "📋 Next steps:"
echo "1. Run: flutter pub get"
echo "2. Run: flutter run"
echo "3. Start developing your features!"
