import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class ProductModel extends HiveObject {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String productCode;
  
  @HiveField(2)
  final String productName;
  
  @HiveField(3)
  final String? description;
  
  @HiveField(4)
  final int categoryId;
  
  @HiveField(5)
  final String? category;
  
  @HiveField(6)
  final String unitOfMeasure;
  
  @HiveField(7)
  final double costPrice;
  
  @HiveField(8)
  final double sellingPrice;
  
  @HiveField(9)
  final String taxType;
  
  @HiveField(10)
  final int? reorderLevel;
  
  @HiveField(11)
  final int? currentStock;
  
  @HiveField(12)
  final bool isActive;
  
  @HiveField(13)
  final DateTime? createdAt;
  
  @HiveField(14)
  final DateTime? updatedAt;

  ProductModel({
    required this.id,
    required this.productCode,
    required this.productName,
    this.description,
    required this.categoryId,
    this.category,
    required this.unitOfMeasure,
    required this.costPrice,
    required this.sellingPrice,
    required this.taxType,
    this.reorderLevel,
    this.currentStock,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  ProductModel copyWith({
    int? id,
    String? productCode,
    String? productName,
    String? description,
    int? categoryId,
    String? category,
    String? unitOfMeasure,
    double? costPrice,
    double? sellingPrice,
    String? taxType,
    int? reorderLevel,
    int? currentStock,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      taxType: taxType ?? this.taxType,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      currentStock: currentStock ?? this.currentStock,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, productCode: $productCode, productName: $productName, category: $category)';
  }
}
