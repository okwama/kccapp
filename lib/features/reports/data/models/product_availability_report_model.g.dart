// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_availability_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductAvailabilityReportModel _$ProductAvailabilityReportModelFromJson(
        Map<String, dynamic> json) =>
    ProductAvailabilityReportModel(
      id: (json['id'] as num?)?.toInt(),
      journeyPlanId: (json['journeyPlanId'] as num?)?.toInt(),
      clientId: (json['clientId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      productName: json['productName'] as String,
      productId: (json['productId'] as num?)?.toInt(),
      quantity: (json['quantity'] as num).toInt(),
      comment: json['comment'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProductAvailabilityReportModelToJson(
        ProductAvailabilityReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'journeyPlanId': instance.journeyPlanId,
      'clientId': instance.clientId,
      'userId': instance.userId,
      'productName': instance.productName,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'comment': instance.comment,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
