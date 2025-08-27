enum JourneyPlanStatus {
  pending(0),
  checkedIn(1),
  inProgress(2),
  completed(3),
  cancelled(4);

  const JourneyPlanStatus(this.value);
  final int value;

  static JourneyPlanStatus fromValue(int value) {
    return JourneyPlanStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => JourneyPlanStatus.pending,
    );
  }

  String get displayName {
    switch (this) {
      case JourneyPlanStatus.pending:
        return 'Pending';
      case JourneyPlanStatus.checkedIn:
        return 'Checked In';
      case JourneyPlanStatus.inProgress:
        return 'In Progress';
      case JourneyPlanStatus.completed:
        return 'Completed';
      case JourneyPlanStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get apiValue {
    switch (this) {
      case JourneyPlanStatus.pending:
        return 'pending';
      case JourneyPlanStatus.checkedIn:
        return 'checked_in';
      case JourneyPlanStatus.inProgress:
        return 'in_progress';
      case JourneyPlanStatus.completed:
        return 'completed';
      case JourneyPlanStatus.cancelled:
        return 'cancelled';
    }
  }
}
