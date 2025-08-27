// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visibility_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisibilityReportModel _$VisibilityReportModelFromJson(
        Map<String, dynamic> json) =>
    VisibilityReportModel(
      id: (json['id'] as num?)?.toInt(),
      journeyPlanId: (json['journeyPlanId'] as num?)?.toInt(),
      clientId: (json['clientId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      comment: json['comment'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$VisibilityReportModelToJson(
        VisibilityReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'journeyPlanId': instance.journeyPlanId,
      'clientId': instance.clientId,
      'userId': instance.userId,
      'comment': instance.comment,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
