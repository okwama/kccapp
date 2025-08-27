// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_of_shelf_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowOfShelfReportModel _$ShowOfShelfReportModelFromJson(
        Map<String, dynamic> json) =>
    ShowOfShelfReportModel(
      id: (json['id'] as num?)?.toInt(),
      journeyPlanId: (json['journeyPlanId'] as num).toInt(),
      clientId: (json['clientId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      productName: json['productName'] as String,
      productId: (json['productId'] as num?)?.toInt(),
      totalItemsOnShelf: (json['totalItemsOnShelf'] as num).toInt(),
      companyItemsOnShelf: (json['companyItemsOnShelf'] as num).toInt(),
      comments: json['comments'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ShowOfShelfReportModelToJson(
        ShowOfShelfReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'journeyPlanId': instance.journeyPlanId,
      'clientId': instance.clientId,
      'userId': instance.userId,
      'productName': instance.productName,
      'productId': instance.productId,
      'totalItemsOnShelf': instance.totalItemsOnShelf,
      'companyItemsOnShelf': instance.companyItemsOnShelf,
      'comments': instance.comments,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
