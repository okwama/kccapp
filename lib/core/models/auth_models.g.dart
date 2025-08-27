// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      phoneNumber: json['phoneNumber'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'password': instance.password,
    };

SalesRep _$SalesRepFromJson(Map<String, dynamic> json) => SalesRep(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone'] as String,
      role: json['role'] as String,
      countryId: (json['countryId'] as num).toInt(),
      regionId: (json['regionId'] as num).toInt(),
      routeId: (json['routeId'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$SalesRepToJson(SalesRep instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phoneNumber,
      'role': instance.role,
      'countryId': instance.countryId,
      'regionId': instance.regionId,
      'routeId': instance.routeId,
      'status': instance.status,
      'photoUrl': instance.photoUrl,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: (json['expiresIn'] as num).toInt(),
      salesRep: SalesRep.fromJson(json['salesRep'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
      'salesRep': instance.salesRep,
    };

AuthState _$AuthStateFromJson(Map<String, dynamic> json) => AuthState(
      isAuthenticated: json['isAuthenticated'] as bool? ?? false,
      isLoading: json['isLoading'] as bool? ?? false,
      error: json['error'] as String?,
      user: json['user'] == null
          ? null
          : SalesRep.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      tokenExpiry: json['tokenExpiry'] == null
          ? null
          : DateTime.parse(json['tokenExpiry'] as String),
    );

Map<String, dynamic> _$AuthStateToJson(AuthState instance) => <String, dynamic>{
      'isAuthenticated': instance.isAuthenticated,
      'isLoading': instance.isLoading,
      'error': instance.error,
      'user': instance.user,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenExpiry': instance.tokenExpiry?.toIso8601String(),
    };
