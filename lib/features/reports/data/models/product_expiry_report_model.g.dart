// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_expiry_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductExpiryReportModel _$ProductExpiryReportModelFromJson(
        Map<String, dynamic> json) =>
    ProductExpiryReportModel(
      id: (json['id'] as num?)?.toInt(),
      journeyPlanId: (json['journeyPlanId'] as num).toInt(),
      clientId: (json['clientId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      productName: json['productName'] as String,
      productId: (json['productId'] as num?)?.toInt(),
      quantity: (json['quantity'] as num).toInt(),
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      batchNumber: json['batchNumber'] as String?,
      comments: json['comments'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProductExpiryReportModelToJson(
        ProductExpiryReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'journeyPlanId': instance.journeyPlanId,
      'clientId': instance.clientId,
      'userId': instance.userId,
      'productName': instance.productName,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'batchNumber': instance.batchNumber,
      'comments': instance.comments,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
