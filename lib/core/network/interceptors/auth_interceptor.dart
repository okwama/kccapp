import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  static const String _accessTokenKey = 'access_token';

  AuthInterceptor({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip token for login endpoint
    if (options.path.contains('/auth/login')) {
      return handler.next(options);
    }

    // Add token to request headers
    final token = await _secureStorage.read(key: _accessTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      // Token might be expired, try to refresh
      final refreshToken = await _secureStorage.read(key: 'refresh_token');

      if (refreshToken != null) {
        try {
          // Attempt to refresh the token
          final response = await Dio().post(
            '${err.requestOptions.baseUrl}/auth/refresh',
            data: {'refreshToken': refreshToken},
          );

          final newAccessToken = response.data['accessToken'];
          await _secureStorage.write(
              key: _accessTokenKey, value: newAccessToken);

          // Retry the original request with new token
          final retryOptions = err.requestOptions;
          retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          final retryResponse = await Dio().fetch(retryOptions);
          return handler.resolve(retryResponse);
        } catch (refreshError) {
          // Refresh failed, clear tokens and redirect to login
          await _clearTokens();
          // You might want to emit an event here to notify the app to redirect to login
        }
      } else {
        // No refresh token, clear tokens
        await _clearTokens();
      }
    }

    handler.next(err);
  }

  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: 'refresh_token');
    await _secureStorage.delete(key: 'user_data');
    await _secureStorage.delete(key: 'token_expiry');
  }
}
