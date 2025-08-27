// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: (json['id'] as num).toInt(),
      productCode: json['productCode'] as String,
      productName: json['productName'] as String,
      description: json['description'] as String?,
      categoryId: (json['categoryId'] as num).toInt(),
      category: json['category'] as String?,
      unitOfMeasure: json['unitOfMeasure'] as String,
      costPrice: (json['costPrice'] as num).toDouble(),
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      taxType: json['taxType'] as String,
      reorderLevel: (json['reorderLevel'] as num?)?.toInt(),
      currentStock: (json['currentStock'] as num?)?.toInt(),
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productCode': instance.productCode,
      'productName': instance.productName,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'category': instance.category,
      'unitOfMeasure': instance.unitOfMeasure,
      'costPrice': instance.costPrice,
      'sellingPrice': instance.sellingPrice,
      'taxType': instance.taxType,
      'reorderLevel': instance.reorderLevel,
      'currentStock': instance.currentStock,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
