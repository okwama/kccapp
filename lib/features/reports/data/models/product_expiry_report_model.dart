import 'package:json_annotation/json_annotation.dart';

part 'product_expiry_report_model.g.dart';

@JsonSerializable()
class ProductExpiryReportModel {
  final int? id;
  final int journeyPlanId;
  final int clientId;
  final int userId;
  final String productName;
  final int? productId;
  final int quantity;
  final DateTime? expiryDate;
  final String? batchNumber;
  final String? comments;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductExpiryReportModel({
    this.id,
    required this.journeyPlanId,
    required this.clientId,
    required this.userId,
    required this.productName,
    this.productId,
    required this.quantity,
    this.expiryDate,
    this.batchNumber,
    this.comments,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductExpiryReportModel.fromJson(Map<String, dynamic> json) =>
      _$ProductExpiryReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductExpiryReportModelToJson(this);

  ProductExpiryReportModel copyWith({
    int? id,
    int? journeyPlanId,
    int? clientId,
    int? userId,
    String? productName,
    int? productId,
    int? quantity,
    DateTime? expiryDate,
    String? batchNumber,
    String? comments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductExpiryReportModel(
      id: id ?? this.id,
      journeyPlanId: journeyPlanId ?? this.journeyPlanId,
      clientId: clientId ?? this.clientId,
      userId: userId ?? this.userId,
      productName: productName ?? this.productName,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      expiryDate: expiryDate ?? this.expiryDate,
      batchNumber: batchNumber ?? this.batchNumber,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
