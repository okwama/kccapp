import 'package:json_annotation/json_annotation.dart';

part 'feedback_report_model.g.dart';

@JsonSerializable()
class FeedbackReportModel {
  final int? id;
  final int? journeyPlanId;
  final int clientId;
  final int userId;
  final String comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FeedbackReportModel({
    this.id,
    this.journeyPlanId,
    required this.clientId,
    required this.userId,
    required this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory FeedbackReportModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackReportModelToJson(this);

  FeedbackReportModel copyWith({
    int? id,
    int? journeyPlanId,
    int? clientId,
    int? userId,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FeedbackReportModel(
      id: id ?? this.id,
      journeyPlanId: journeyPlanId ?? this.journeyPlanId,
      clientId: clientId ?? this.clientId,
      userId: userId ?? this.userId,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
