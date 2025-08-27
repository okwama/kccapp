import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth_models.dart';
import '../network/api_client.dart';
import '../constants/app_constants.dart';

class AuthService {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _tokenExpiryKey = 'token_expiry';

  AuthService({
    required ApiClient apiClient,
    required FlutterSecureStorage secureStorage,
  })  : _apiClient = apiClient,
        _secureStorage = secureStorage;

  /// Login with phone number and password
  Future<LoginResponse> login(String phoneNumber, String password) async {
    try {
      final request = LoginRequest(
        phoneNumber: phoneNumber,
        password: password,
      );

      final response = await _apiClient.dio.post(
        '/auth/login',
        data: request.toJson(),
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      // Store tokens and user data
      await _storeAuthData(loginResponse);

      return loginResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid credentials');
      } else if (e.response?.statusCode == 400) {
        throw Exception('Invalid phone number format');
      } else {
        throw Exception('Login failed. Please try again.');
      }
    } catch (e) {
      throw Exception('Network error. Please check your connection.');
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // Call logout endpoint if token is available
      final token = await _secureStorage.read(key: _accessTokenKey);
      if (token != null) {
        await _apiClient.dio.post(
          '/auth/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }
    } catch (e) {
      // Continue with logout even if API call fails
    } finally {
      // Clear stored data
      await _clearAuthData();
    }
  }

  /// Get current user profile
  Future<SalesRep> getProfile() async {
    try {
      final response = await _apiClient.dio.get('/auth/profile');
      return SalesRep.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Token expired');
      }
      throw Exception('Failed to get profile');
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: _accessTokenKey);
    if (token == null) return false;

    final expiryString = await _secureStorage.read(key: _tokenExpiryKey);
    if (expiryString == null) return false;

    final expiry = DateTime.parse(expiryString);
    return DateTime.now().isBefore(expiry);
  }

  /// Get stored user data
  Future<SalesRep?> getStoredUser() async {
    final userData = await _secureStorage.read(key: _userDataKey);
    if (userData == null) return null;

    try {
      // Parse the JSON string back to Map
      final Map<String, dynamic> userMap = jsonDecode(userData);
      return SalesRep.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  /// Get stored access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  /// Refresh access token
  Future<String?> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
      if (refreshToken == null) return null;

      final response = await _apiClient.dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final newAccessToken = response.data['accessToken'];
      await _secureStorage.write(key: _accessTokenKey, value: newAccessToken);

      return newAccessToken;
    } catch (e) {
      await _clearAuthData();
      return null;
    }
  }

  /// Store authentication data securely
  Future<void> _storeAuthData(LoginResponse loginResponse) async {
    await _secureStorage.write(
      key: _accessTokenKey,
      value: loginResponse.accessToken,
    );

    await _secureStorage.write(
      key: _refreshTokenKey,
      value: loginResponse.refreshToken,
    );

    await _secureStorage.write(
      key: _userDataKey,
      value: jsonEncode(loginResponse.salesRep.toJson()),
    );

    // Calculate and store token expiry
    final expiry =
        DateTime.now().add(Duration(seconds: loginResponse.expiresIn));
    await _secureStorage.write(
      key: _tokenExpiryKey,
      value: expiry.toIso8601String(),
    );
  }

  /// Clear all stored authentication data
  Future<void> _clearAuthData() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _userDataKey);
    await _secureStorage.delete(key: _tokenExpiryKey);
  }

  /// Validate phone number format
  bool isValidPhoneNumber(String phoneNumber) {
    // Match the API validation pattern: /^[0-9+\-\s()]+$/
    final phoneRegex = RegExp(r'^[0-9+\-\s()]+$');
    return phoneRegex.hasMatch(phoneNumber) && phoneNumber.length >= 10;
  }

  /// Validate password
  bool isValidPassword(String password) {
    return password.length >= 6;
  }
}
