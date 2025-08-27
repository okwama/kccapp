import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/journey_plan.dart';
import '../../domain/entities/journey_plan_status.dart';

class JourneyPlanCard extends StatelessWidget {
  final JourneyPlan journeyPlan;
  final VoidCallback onTap;
  final VoidCallback? onCheckIn;
  final VoidCallback? onCheckOut;
  final VoidCallback? onDelete;

  const JourneyPlanCard({
    super.key,
    required this.journeyPlan,
    required this.onTap,
    this.onCheckIn,
    this.onCheckOut,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;
    final isCompleted = journeyPlan.status == JourneyPlanStatus.completed.value;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: 6,
      ),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getStatusColor(journeyPlan.status).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: isCompleted
          ? _buildCompletedCard(context, isCompact)
          : InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: _buildCardContent(context, isCompact),
            ),
    );
  }

  Widget _buildCompletedCard(BuildContext context, bool isCompact) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[50],
      ),
      child: Stack(
        children: [
          _buildCardContent(context, isCompact),
          // Overlay to indicate it's not interactive
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 8 : 12,
                    vertical: isCompact ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[700]!.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isCompact ? 10 : 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, bool isCompact) {
    return Padding(
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main content row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status indicator
              Container(
                width: isCompact ? 32 : 36,
                height: isCompact ? 32 : 36,
                decoration: BoxDecoration(
                  color: _getStatusColor(journeyPlan.status),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getStatusIcon(journeyPlan.status),
                  color: Colors.white,
                  size: isCompact ? 16 : 18,
                ),
              ),
              SizedBox(width: isCompact ? 10 : 12),

              // Client and status info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Client name
                    Text(
                      journeyPlan.client?.name ?? 'Unknown Client',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isCompact ? 15 : 16,
                        color: Colors.grey[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Status badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isCompact ? 6 : 8,
                        vertical: isCompact ? 2 : 3,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(journeyPlan.status)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(journeyPlan.status),
                        style: TextStyle(
                          color: _getStatusColor(journeyPlan.status),
                          fontSize: isCompact ? 10 : 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Time and date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    journeyPlan.time,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: isCompact ? 13 : 14,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    DateFormat('MMM dd').format(journeyPlan.date),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: isCompact ? 10 : 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Notes section (if exists)
          if (journeyPlan.notes?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isCompact ? 6 : 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 0.5,
                ),
              ),
              child: Text(
                journeyPlan.notes!,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: isCompact ? 12 : 13,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],

          // Bottom row with route info and actions
          const SizedBox(height: 8),
          Row(
            children: [
              // Route info
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.route,
                      size: isCompact ? 12 : 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Route ${journeyPlan.routeId ?? 'N/A'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: isCompact ? 10 : 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Action buttons (only show for non-completed status)
              if (journeyPlan.status != JourneyPlanStatus.completed.value) ...[
                if (journeyPlan.status == JourneyPlanStatus.pending.value) ...[
                  if (onDelete != null)
                    _buildActionButton(
                      icon: Icons.delete_outline,
                      color: Colors.red,
                      onTap: onDelete!,
                      isCompact: isCompact,
                      tooltip: 'Delete',
                    ),
                ] else if (journeyPlan.status ==
                    JourneyPlanStatus.checkedIn.value) ...[
                  if (onCheckOut != null)
                    _buildActionButton(
                      icon: Icons.logout,
                      color: Colors.green,
                      onTap: onCheckOut!,
                      isCompact: isCompact,
                      tooltip: 'Check Out',
                    ),
                ],
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isCompact,
    required String tooltip,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isCompact ? 6 : 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Icon(
          icon,
          size: isCompact ? 16 : 18,
          color: color,
        ),
      ),
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.purple;
      case 3:
        return Colors.green;
      case 4:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icons.schedule;
      case 1:
        return Icons.location_on;
      case 2:
        return Icons.work;
      case 3:
        return Icons.check_circle;
      case 4:
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Checked In';
      case 2:
        return 'In Progress';
      case 3:
        return 'Completed';
      case 4:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}
