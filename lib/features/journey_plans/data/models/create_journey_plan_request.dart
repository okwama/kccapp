import 'package:json_annotation/json_annotation.dart';

part 'create_journey_plan_request.g.dart';

@JsonSerializable()
class CreateJourneyPlanRequest {
  @JsonKey(name: 'clientId')
  final int clientId;
  final String date;
  final String time;
  final String? notes;
  @JsonKey(name: 'routeId')
  final int? routeId;

  const CreateJourneyPlanRequest({
    required this.clientId,
    required this.date,
    required this.time,
    this.notes,
    this.routeId,
  });

  factory CreateJourneyPlanRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateJourneyPlanRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateJourneyPlanRequestToJson(this);
}
