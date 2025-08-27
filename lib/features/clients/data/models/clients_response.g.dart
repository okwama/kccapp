// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clients_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientsResponse _$ClientsResponseFromJson(Map<String, dynamic> json) =>
    ClientsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ClientModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
      success: json['success'] as bool,
    );

Map<String, dynamic> _$ClientsResponseToJson(ClientsResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'pagination': instance.pagination,
      'success': instance.success,
    };

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'totalPages': instance.totalPages,
    };
