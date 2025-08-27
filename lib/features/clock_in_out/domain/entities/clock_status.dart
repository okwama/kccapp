import 'clock_session.dart';

class ClockStatus {
  final bool isClockedIn;
  final ClockSession? currentSession;
  final String message;

  const ClockStatus({
    required this.isClockedIn,
    this.currentSession,
    required this.message,
  });

  factory ClockStatus.notClockedIn() {
    return const ClockStatus(
      isClockedIn: false,
      currentSession: null,
      message: 'Not clocked in',
    );
  }

  factory ClockStatus.clockedIn(ClockSession session) {
    return ClockStatus(
      isClockedIn: true,
      currentSession: session,
      message: 'Clocked in',
    );
  }

  ClockStatus copyWith({
    bool? isClockedIn,
    ClockSession? currentSession,
    String? message,
  }) {
    return ClockStatus(
      isClockedIn: isClockedIn ?? this.isClockedIn,
      currentSession: currentSession ?? this.currentSession,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'ClockStatus(isClockedIn: $isClockedIn, currentSession: $currentSession, message: $message)';
  }
}
