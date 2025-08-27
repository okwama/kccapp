import 'package:json_annotation/json_annotation.dart';

part 'visibility_report_model.g.dart';

@JsonSerializable()
class VisibilityReportModel {
  final int? id;
  final int? journeyPlanId;
  final int clientId;
  final int userId;
  final String comment;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VisibilityReportModel({
    this.id,
    this.journeyPlanId,
    required this.clientId,
    required this.userId,
    required this.comment,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory VisibilityReportModel.fromJson(Map<String, dynamic> json) =>
      _$VisibilityReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$VisibilityReportModelToJson(this);

  VisibilityReportModel copyWith({
    int? id,
    int? journeyPlanId,
    int? clientId,
    int? userId,
    String? comment,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VisibilityReportModel(
      id: id ?? this.id,
      journeyPlanId: journeyPlanId ?? this.journeyPlanId,
      clientId: clientId ?? this.clientId,
      userId: userId ?? this.userId,
      comment: comment ?? this.comment,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
