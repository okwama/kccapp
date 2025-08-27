import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/providers.dart';
import '../providers/clock_in_out_providers.dart';

class ClockInOutWidget extends ConsumerStatefulWidget {
  const ClockInOutWidget({super.key});

  @override
  ConsumerState<ClockInOutWidget> createState() => _ClockInOutWidgetState();
}

class _ClockInOutWidgetState extends ConsumerState<ClockInOutWidget> {
  @override
  void initState() {
    super.initState();
    // Load clock status when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState.isAuthenticated && authState.user != null) {
        ref
            .read(clockInOutNotifierProvider.notifier)
            .loadClockStatus(authState.user!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final clockState = ref.watch(clockInOutNotifierProvider);

    if (!authState.isAuthenticated || authState.user == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: clockState.status.isClockedIn
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    clockState.status.isClockedIn
                        ? Icons.access_time_filled
                        : Icons.access_time,
                    color: clockState.status.isClockedIn
                        ? AppColors.success
                        : AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clockState.status.isClockedIn
                            ? 'Currently Working'
                            : 'Ready to Start',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getStatusMessage(clockState),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusIndicator(clockState),
              ],
            ),

            // Working Time Display
            if (clockState.status.isClockedIn &&
                clockState.status.currentSession != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.success.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer,
                      color: AppColors.success,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Working Time: ${clockState.status.currentSession!.formattedDuration}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isButtonEnabled(clockState)
                    ? () => _handleClockAction(authState.user!.id)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: clockState.status.isClockedIn
                      ? AppColors.error
                      : AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                icon: _getButtonIcon(clockState),
                label: Text(
                  _getButtonText(clockState),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Error Display
            if (clockState.error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.error.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        clockState.error!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(clockInOutNotifierProvider.notifier)
                            .clearError();
                      },
                      icon: Icon(
                        Icons.close,
                        color: AppColors.error,
                        size: 16,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(clockState) {
    if (clockState.isLoading) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: clockState.status.isClockedIn
            ? AppColors.success
            : AppColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }

  String _getStatusMessage(clockState) {
    if (clockState.isLoading) return 'Loading status...';
    if (clockState.status.isClockedIn) {
      final session = clockState.status.currentSession;
      if (session != null) {
        final startTime = session.startDateTime;
        return 'Started at ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
      }
      return 'Currently clocked in';
    }
    return 'Tap below to start your work day';
  }

  Widget _getButtonIcon(clockState) {
    if (clockState.isClockingIn || clockState.isClockingOut) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return Icon(
      clockState.status.isClockedIn ? Icons.logout : Icons.login,
    );
  }

  String _getButtonText(clockState) {
    if (clockState.isClockingIn) return 'Clocking In...';
    if (clockState.isClockingOut) return 'Clocking Out...';
    return clockState.status.isClockedIn ? 'Clock Out' : 'Clock In';
  }

  bool _isButtonEnabled(clockState) {
    return !clockState.isLoading &&
        !clockState.isClockingIn &&
        !clockState.isClockingOut;
  }

  Future<void> _handleClockAction(int userId) async {
    final clockNotifier = ref.read(clockInOutNotifierProvider.notifier);
    final clockState = ref.read(clockInOutNotifierProvider);

    bool success;
    if (clockState.status.isClockedIn) {
      success = await clockNotifier.clockOut(userId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Successfully clocked out!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      success = await clockNotifier.clockIn(userId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Successfully clocked in!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(clockState.error ?? 'Operation failed'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
