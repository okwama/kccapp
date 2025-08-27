import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/client.dart';
import '../../../../core/constants/app_colors.dart';

class ClientDetailsPage extends ConsumerWidget {
  final int clientId;

  const ClientDetailsPage({
    super.key,
    required this.clientId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now, we'll show a placeholder since we need to implement
    // a provider to fetch individual client details
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              // TODO: Navigate to map view
            },
            tooltip: 'View on Map',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_outline,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Client Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Client ID: $clientId',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Client details page will be implemented\nwith full client information display.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder widget for when we have the actual client data
class ClientDetailsContent extends StatelessWidget {
  final Client client;

  const ClientDetailsContent({
    super.key,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Client Header
          _buildClientHeader(),
          const SizedBox(height: 24),

          // Contact Information
          _buildSection(
            title: 'Contact Information',
            icon: Icons.contact_phone,
            children: [
              _buildInfoRow('Name', client.name),
              if (client.contact?.isNotEmpty == true)
                _buildInfoRow('Phone', client.contact!),
              if (client.email?.isNotEmpty == true)
                _buildInfoRow('Email', client.email!),
            ],
          ),

          // Location Information
          if (client.address?.isNotEmpty == true ||
              client.region.isNotEmpty ||
              client.routeName?.isNotEmpty == true)
            _buildSection(
              title: 'Location',
              icon: Icons.location_on,
              children: [
                if (client.address?.isNotEmpty == true)
                  _buildInfoRow('Address', client.address!),
                if (client.region.isNotEmpty)
                  _buildInfoRow('Region', client.region),
                if (client.routeName?.isNotEmpty == true)
                  _buildInfoRow('Route', client.routeName!),
                if (client.latitude != null && client.longitude != null)
                  _buildInfoRow('Coordinates',
                      '${client.latitude!.toStringAsFixed(6)}, ${client.longitude!.toStringAsFixed(6)}'),
              ],
            ),

          // Business Information
          _buildSection(
            title: 'Business Information',
            icon: Icons.business,
            children: [
              _buildInfoRow('Status', _getStatusText(client.status)),
              if (client.balance != null)
                _buildInfoRow(
                    'Balance', '\$${client.balance!.toStringAsFixed(2)}',
                    valueColor: client.balance! > 0 ? AppColors.error : null),
              if (client.taxPin?.isNotEmpty == true)
                _buildInfoRow('Tax PIN', client.taxPin!),
              if (client.clientType != null)
                _buildInfoRow('Client Type', client.clientType.toString()),
            ],
          ),

          // Actions
          const SizedBox(height: 24),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildClientHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primary,
              child: Text(
                client.name.isNotEmpty ? client.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(client.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(client.status).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _getStatusText(client.status),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(client.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: valueColor ?? Colors.black87,
                fontWeight:
                    valueColor != null ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to create journey plan
            },
            icon: const Icon(Icons.map),
            label: const Text('Create Journey Plan'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Navigate to create order
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Create Order'),
          ),
        ),
      ],
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Active';
      case 0:
        return 'Inactive';
      default:
        return 'Pending';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
        return AppColors.success;
      case 0:
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }
}
