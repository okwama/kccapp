// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 1;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as int,
      productCode: fields[1] as String,
      productName: fields[2] as String,
      description: fields[3] as String?,
      categoryId: fields[4] as int,
      category: fields[5] as String?,
      unitOfMeasure: fields[6] as String,
      costPrice: fields[7] as double,
      sellingPrice: fields[8] as double,
      taxType: fields[9] as String,
      reorderLevel: fields[10] as int?,
      currentStock: fields[11] as int?,
      isActive: fields[12] as bool,
      createdAt: fields[13] as DateTime?,
      updatedAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productCode)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.categoryId)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.unitOfMeasure)
      ..writeByte(7)
      ..write(obj.costPrice)
      ..writeByte(8)
      ..write(obj.sellingPrice)
      ..writeByte(9)
      ..write(obj.taxType)
      ..writeByte(10)
      ..write(obj.reorderLevel)
      ..writeByte(11)
      ..write(obj.currentStock)
      ..writeByte(12)
      ..write(obj.isActive)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
