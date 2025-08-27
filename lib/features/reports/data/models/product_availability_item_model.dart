import 'package:json_annotation/json_annotation.dart';

part 'product_availability_item_model.g.dart';

@JsonSerializable()
class ProductAvailabilityItemModel {
  final String productName;
  final int? productId;
  final int quantity;
  final String? comment;

  ProductAvailabilityItemModel({
    required this.productName,
    this.productId,
    required this.quantity,
    this.comment,
  });

  factory ProductAvailabilityItemModel.fromJson(Map<String, dynamic> json) =>
      _$ProductAvailabilityItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductAvailabilityItemModelToJson(this);

  ProductAvailabilityItemModel copyWith({
    String? productName,
    int? productId,
    int? quantity,
    String? comment,
  }) {
    return ProductAvailabilityItemModel(
      productName: productName ?? this.productName,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      comment: comment ?? this.comment,
    );
  }
}
