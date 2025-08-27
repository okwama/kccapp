import 'package:json_annotation/json_annotation.dart';
import 'journey_plan_model.dart';

part 'journey_plan_response.g.dart';

@JsonSerializable()
class JourneyPlanResponse {
  final List<JourneyPlanModel> data;
  final PaginationModel pagination;
  final bool success;

  const JourneyPlanResponse({
    required this.data,
    required this.pagination,
    required this.success,
  });

  factory JourneyPlanResponse.fromJson(Map<String, dynamic> json) =>
      _$JourneyPlanResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JourneyPlanResponseToJson(this);
}

@JsonSerializable()
class PaginationModel {
  final int total;
  final int page;
  final int limit;
  @JsonKey(name: 'totalPages')
  final int totalPages;

  const PaginationModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
}
