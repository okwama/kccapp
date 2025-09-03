import 'package:flutter/material.dart';
import '../../domain/entities/client.dart';
import '../../../../core/constants/app_colors.dart';

class ClientCard extends StatelessWidget {
  final Client client;
  final VoidCallback? onTap;

  const ClientCard({
    super.key,
    required this.client,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: Text(
                  client.name.isNotEmpty ? client.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Client Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name and Status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            client.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildCompactStatusChip(),
                      ],
                    ),

                    const SizedBox(height: 2),

                    // Contact and Region
                    Row(
                      children: [
                        if (client.contact?.isNotEmpty == true) ...[
                          Icon(
                            Icons.phone_outlined,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              client.contact!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (client.region.isNotEmpty) ...[
                          Icon(
                            Icons.business_outlined,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            client.region,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 2),

                    // Address and Balance
                    Row(
                      children: [
                        if (client.address?.isNotEmpty == true) ...[
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              client.address!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        if (client.balance != null && client.balance! > 0) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 14,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '\$${client.balance!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow indicator
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactStatusChip() {
    Color chipColor;
    String statusText;
    IconData statusIcon;

    switch (client.status) {
      case 1:
        chipColor = AppColors.success;
        statusText = 'Active';
        statusIcon = Icons.check_circle_outline;
        break;
      case 0:
        chipColor = AppColors.error;
        statusText = 'Inactive';
        statusIcon = Icons.cancel_outlined;
        break;
      default:
        chipColor = AppColors.warning;
        statusText = 'Pending';
        statusIcon = Icons.pending_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 12,
            color: chipColor,
          ),
          const SizedBox(width: 3),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 11,
              color: chipColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
