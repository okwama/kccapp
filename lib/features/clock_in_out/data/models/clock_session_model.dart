import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/clock_session.dart';

part 'clock_session_model.g.dart';

@JsonSerializable()
class ClockSessionModel extends ClockSession {
  const ClockSessionModel({
    required super.id,
    required super.userId,
    super.timezone,
    super.duration,
    required super.status,
    super.sessionEnd,
    required super.sessionStart,
  });

  factory ClockSessionModel.fromJson(Map<String, dynamic> json) =>
      _$ClockSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClockSessionModelToJson(this);

  factory ClockSessionModel.fromEntity(ClockSession entity) {
    return ClockSessionModel(
      id: entity.id,
      userId: entity.userId,
      timezone: entity.timezone,
      duration: entity.duration,
      status: entity.status,
      sessionEnd: entity.sessionEnd,
      sessionStart: entity.sessionStart,
    );
  }

  ClockSession toEntity() {
    return ClockSession(
      id: id,
      userId: userId,
      timezone: timezone,
      duration: duration,
      status: status,
      sessionEnd: sessionEnd,
      sessionStart: sessionStart,
    );
  }
}
