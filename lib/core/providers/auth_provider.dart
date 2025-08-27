import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState());

  /// Initialize authentication state from stored data
  Future<void> initializeAuth() async {
    state = state.copyWith(isLoading: true);

    try {
      final isAuthenticated = await _authService.isAuthenticated();

      if (isAuthenticated) {
        final user = await _authService.getStoredUser();
        final token = await _authService.getAccessToken();

        if (user != null && token != null) {
          state = state.copyWith(
            isAuthenticated: true,
            user: user,
            accessToken: token,
            isLoading: false,
          );
        } else {
          await logout();
        }
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to initialize authentication',
        isLoading: false,
      );
    }
  }

  /// Login with phone number and password
  Future<void> login(String phoneNumber, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Validate input
      if (!_authService.isValidPhoneNumber(phoneNumber)) {
        throw Exception('Invalid phone number format');
      }

      if (!_authService.isValidPassword(password)) {
        throw Exception('Password must be at least 6 characters');
      }

      final loginResponse = await _authService.login(phoneNumber, password);

      state = state.copyWith(
        isAuthenticated: true,
        user: loginResponse.salesRep,
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
        tokenExpiry:
            DateTime.now().add(Duration(seconds: loginResponse.expiresIn)),
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceAll('Exception: ', ''),
        isLoading: false,
      );
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.logout();
      state = AuthState(isLoading: false);
    } catch (e) {
      // Even if logout fails, clear the state
      state = AuthState(
        isLoading: false,
        error: 'Logout failed but session cleared',
      );
    }
  }

  /// Refresh user profile
  Future<void> refreshProfile() async {
    if (!state.isAuthenticated) return;

    try {
      final user = await _authService.getProfile();
      state = state.copyWith(user: user);
    } catch (e) {
      // If profile refresh fails, user might be logged out
      if (e.toString().contains('Token expired')) {
        await logout();
      }
    }
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Check if token is expired
  bool get isTokenExpired {
    return state.isTokenExpired;
  }

  /// Get current user
  SalesRep? get currentUser => state.user;

  /// Get access token
  String? get accessToken => state.accessToken;
}
