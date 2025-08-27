class ClockSession {
  final int id;
  final int userId;
  final String? timezone;
  final int? duration;
  final int status; // 0=ended, 1=active, 2=paused
  final String? sessionEnd;
  final String sessionStart;

  const ClockSession({
    required this.id,
    required this.userId,
    this.timezone,
    this.duration,
    required this.status,
    this.sessionEnd,
    required this.sessionStart,
  });

  bool get isActive => status == 1;
  bool get isPaused => status == 2;
  bool get isEnded => status == 0;

  String get statusText {
    switch (status) {
      case 1:
        return 'Active';
      case 2:
        return 'Paused';
      case 0:
        return 'Ended';
      default:
        return 'Unknown';
    }
  }

  DateTime get startDateTime {
    try {
      // Parse the session start time
      final parsed = DateTime.parse(sessionStart);

      // If the parsed time is in the future, it might be a timezone issue
      // For now, let's use the current time as the session start time
      // This is a temporary fix until we handle timezones properly
      if (parsed.isAfter(DateTime.now())) {
        print('⚠️ Session start time is in the future: $sessionStart');
        print('⚠️ Using current time as session start time');
        return DateTime.now()
            .subtract(const Duration(minutes: 1)); // Start 1 minute ago
      }

      return parsed;
    } catch (e) {
      print('❌ Error parsing sessionStart: $sessionStart, Error: $e');
      // Return current time as fallback
      return DateTime.now().subtract(const Duration(minutes: 1));
    }
  }

  DateTime? get endDateTime =>
      sessionEnd != null ? DateTime.parse(sessionEnd!) : null;

  Duration? get sessionDuration {
    print('🔍 sessionDuration calculation:');
    print('  - duration: $duration');
    print('  - sessionEnd: $sessionEnd');
    print('  - isActive: $isActive');
    print('  - startDateTime: $startDateTime');
    print('  - current time: ${DateTime.now()}');

    // For active sessions, always use real-time calculation
    if (isActive) {
      final diff = DateTime.now().difference(startDateTime);
      print('  - Using real-time difference: $diff');
      return diff;
    }

    // For ended sessions, use the duration field if available
    if (duration != null && duration! > 0) {
      print('  - Using duration field: ${Duration(seconds: duration!)}');
      return Duration(seconds: duration!);
    }

    if (sessionEnd != null) {
      final diff = endDateTime!.difference(startDateTime);
      print('  - Using sessionEnd difference: $diff');
      return diff;
    }

    print('  - No duration calculated');
    return null;
  }

  String get formattedDuration {
    final dur = sessionDuration;
    if (dur == null) return '--:--';

    final hours = dur.inHours;
    final minutes = dur.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  ClockSession copyWith({
    int? id,
    int? userId,
    String? timezone,
    int? duration,
    int? status,
    String? sessionEnd,
    String? sessionStart,
  }) {
    return ClockSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timezone: timezone ?? this.timezone,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      sessionEnd: sessionEnd ?? this.sessionEnd,
      sessionStart: sessionStart ?? this.sessionStart,
    );
  }

  @override
  String toString() {
    return 'ClockSession(id: $id, userId: $userId, status: $status, sessionStart: $sessionStart, sessionEnd: $sessionEnd)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClockSession && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
