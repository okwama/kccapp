import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final int id;
  final String productCode;
  final String productName;
  final String? description;
  final int categoryId;
  final String? category;
  final String unitOfMeasure;
  final double costPrice;
  final double sellingPrice;
  final String taxType;
  final int? reorderLevel;
  final int? currentStock;
  final bool isActive;
  final DateTime? createdAt;
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
