import 'package:json_annotation/json_annotation.dart';

part 'show_of_shelf_report_model.g.dart';

@JsonSerializable()
class ShowOfShelfReportModel {
  final int? id;
  final int journeyPlanId;
  final int clientId;
  final int userId;
  final String productName;
  final int? productId;
  final int totalItemsOnShelf;
  final int companyItemsOnShelf;
  final String? comments;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ShowOfShelfReportModel({
    this.id,
    required this.journeyPlanId,
    required this.clientId,
    required this.userId,
    required this.productName,
    this.productId,
    required this.totalItemsOnShelf,
    required this.companyItemsOnShelf,
    this.comments,
    this.createdAt,
    this.updatedAt,
  });

  factory ShowOfShelfReportModel.fromJson(Map<String, dynamic> json) =>
      _$ShowOfShelfReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShowOfShelfReportModelToJson(this);

  ShowOfShelfReportModel copyWith({
    int? id,
    int? journeyPlanId,
    int? clientId,
    int? userId,
    String? productName,
    int? productId,
    int? totalItemsOnShelf,
    int? companyItemsOnShelf,
    String? comments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShowOfShelfReportModel(
      id: id ?? this.id,
      journeyPlanId: journeyPlanId ?? this.journeyPlanId,
      clientId: clientId ?? this.clientId,
      userId: userId ?? this.userId,
      productName: productName ?? this.productName,
      productId: productId ?? this.productId,
      totalItemsOnShelf: totalItemsOnShelf ?? this.totalItemsOnShelf,
      companyItemsOnShelf: companyItemsOnShelf ?? this.companyItemsOnShelf,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
