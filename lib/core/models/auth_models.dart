import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class LoginRequest {
  @JsonKey(name: 'phoneNumber')
  final String phoneNumber;

  final String password;

  LoginRequest({
    required this.phoneNumber,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class SalesRep {
  final int id;
  final String name;
  final String email;
  @JsonKey(name: 'phone')
  final String phoneNumber;
  final String role;
  @JsonKey(name: 'countryId')
  final int countryId;
  @JsonKey(name: 'regionId')
  final int regionId;
  @JsonKey(name: 'routeId')
  final int routeId;
  final int status;
  @JsonKey(name: 'photoUrl')
  final String? photoUrl;

  SalesRep({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.countryId,
    required this.regionId,
    required this.routeId,
    required this.status,
    this.photoUrl,
  });

  factory SalesRep.fromJson(Map<String, dynamic> json) =>
      _$SalesRepFromJson(json);

  Map<String, dynamic> toJson() => _$SalesRepToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final bool success;
  final String message;
  @JsonKey(name: 'accessToken')
  final String accessToken;
  @JsonKey(name: 'refreshToken')
  final String refreshToken;
  @JsonKey(name: 'expiresIn')
  final int expiresIn;
  @JsonKey(name: 'salesRep')
  final SalesRep salesRep;

  LoginResponse({
    required this.success,
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.salesRep,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final SalesRep? user;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? tokenExpiry;

  AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.user,
    this.accessToken,
    this.refreshToken,
    this.tokenExpiry,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    SalesRep? user,
    String? accessToken,
    String? refreshToken,
    DateTime? tokenExpiry,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenExpiry: tokenExpiry ?? this.tokenExpiry,
    );
  }

  bool get isTokenExpired {
    if (tokenExpiry == null) return true;
    return DateTime.now().isAfter(tokenExpiry!);
  }

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);

  Map<String, dynamic> toJson() => _$AuthStateToJson(this);
}
