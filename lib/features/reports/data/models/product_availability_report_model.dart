import 'package:json_annotation/json_annotation.dart';

part 'product_availability_report_model.g.dart';

@JsonSerializable()
class ProductAvailabilityReportModel {
  final int? id;
  final int? journeyPlanId;
  final int clientId;
  final int userId;
  final String productName;
  final int? productId;
  final int quantity;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductAvailabilityReportModel({
    this.id,
    this.journeyPlanId,
    required this.clientId,
    required this.userId,
    required this.productName,
    this.productId,
    required this.quantity,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductAvailabilityReportModel.fromJson(Map<String, dynamic> json) =>
      _$ProductAvailabilityReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductAvailabilityReportModelToJson(this);

  ProductAvailabilityReportModel copyWith({
    int? id,
    int? journeyPlanId,
    int? clientId,
    int? userId,
    String? productName,
    int? productId,
    int? quantity,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductAvailabilityReportModel(
      id: id ?? this.id,
      journeyPlanId: journeyPlanId ?? this.journeyPlanId,
      clientId: clientId ?? this.clientId,
      userId: userId ?? this.userId,
      productName: productName ?? this.productName,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
