import '../../domain/entities/clock_status.dart';
import '../../domain/entities/clock_session.dart';
import 'clock_session_model.dart';

class ClockStatusModel extends ClockStatus {
  const ClockStatusModel({
    required super.isClockedIn,
    super.currentSession,
    required super.message,
  });

  factory ClockStatusModel.fromEntity(ClockStatus entity) {
    return ClockStatusModel(
      isClockedIn: entity.isClockedIn,
      currentSession: entity.currentSession,
      message: entity.message,
    );
  }

  ClockStatus toEntity() {
    return ClockStatus(
      isClockedIn: isClockedIn,
      currentSession: currentSession,
      message: message,
    );
  }
}
