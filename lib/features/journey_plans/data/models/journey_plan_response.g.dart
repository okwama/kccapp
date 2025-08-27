// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_plan_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JourneyPlanResponse _$JourneyPlanResponseFromJson(Map<String, dynamic> json) =>
    JourneyPlanResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => JourneyPlanModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
      success: json['success'] as bool,
    );

Map<String, dynamic> _$JourneyPlanResponseToJson(
        JourneyPlanResponse instance) =>
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
