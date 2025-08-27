// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_availability_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductAvailabilityItemModel _$ProductAvailabilityItemModelFromJson(
        Map<String, dynamic> json) =>
    ProductAvailabilityItemModel(
      productName: json['productName'] as String,
      productId: (json['productId'] as num?)?.toInt(),
      quantity: (json['quantity'] as num).toInt(),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$ProductAvailabilityItemModelToJson(
        ProductAvailabilityItemModel instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'comment': instance.comment,
    };
