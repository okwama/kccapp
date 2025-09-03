import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/journey_plans/presentation/providers/journey_plans_providers.dart';
import '../../../../core/services/location_service.dart';
import '../providers/reports_providers.dart';

class ReportsSelectionPage extends ConsumerWidget {
  final int journeyPlanId;
  final int clientId;
  final int userId;

  const ReportsSelectionPage({
    super.key,
    required this.journeyPlanId,
    required this.clientId,
    required this.userId,
  });

  static Future<void> _performCheckOut(
      BuildContext context, WidgetRef ref, int journeyPlanId) async {
    // Show initial loading indicator
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          _buildLoadingDialog(context, 'Preparing check-out...'),
    );

    try {
      // Step 1: Get current location
      if (!context.mounted) return;
      _updateLoadingDialog(context, 'Getting your location...');

      final locationResult = await LocationService.getCurrentLocation();

      if (!locationResult.isSuccess) {
        if (!context.mounted) return;
        Navigator.of(context).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location error: ${locationResult.error}'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show location message
      if (locationResult.isDefault) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Using default location (Nairobi)'),
            backgroundColor: Colors.blue,
          ),
        );
      }

      // Step 2: Perform check-out
      if (!context.mounted) return;
      _updateLoadingDialog(context, 'Completing check-out...');

      // Use the journey plan ID passed as parameter
      await ref.read(journeyPlansNotifierProvider.notifier).checkOut(
            journeyPlanId,
            latitude: locationResult.latitude,
            longitude: locationResult.longitude,
          );

      // Step 3: Success and navigation
      if (!context.mounted) return;
      _updateLoadingDialog(context, 'Check-out successful! Redirecting...');

      // Brief pause to show success
      await Future.delayed(const Duration(milliseconds: 800));

      // Don't close the loading dialog here - let it persist during navigation
      // Navigator.of(context).pop(); // Close loading

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Successfully checked out!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back to journey plans page
      if (context.mounted) {
        context.go('/journey-plans');
      }

      // Refresh the journey plans
      ref.read(journeyPlansNotifierProvider.notifier).loadJourneyPlans();
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to check out: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Helper method to build the loading dialog
  static Widget _buildLoadingDialog(BuildContext context, String message) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated loading indicator with primary color
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Message text with better typography
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Subtitle for better context
            Text(
              'Please wait...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to update loading dialog content without closing it
  static void _updateLoadingDialog(BuildContext context, String message) {
    if (!context.mounted) return;

    // Instead of closing and reopening the dialog, just update the current one
    // This prevents the loader from disappearing
    Navigator.of(context).pop();

    // Small delay to ensure smooth transition
    Future.delayed(const Duration(milliseconds: 100), () {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => _buildLoadingDialog(context, message),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;
    final reportsState = ref.watch(reportsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Report Type'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isCompact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header section
            Container(
              padding: EdgeInsets.all(isCompact ? 12 : 16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 0.5,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Choose a report type to submit:',
                    style: TextStyle(
                      fontSize: isCompact ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You can submit multiple reports. After completing reports, check out the journey plan.',
                    style: TextStyle(
                      fontSize: isCompact ? 12 : 14,
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Progress indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: reportsState.completedReports.isNotEmpty
                            ? Colors.green
                            : Colors.grey[400],
                        size: isCompact ? 16 : 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${reportsState.completedReports.length}/5 reports completed',
                        style: TextStyle(
                          fontSize: isCompact ? 12 : 14,
                          fontWeight: FontWeight.w600,
                          color: reportsState.completedReports.isNotEmpty
                              ? Colors.green[700]
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Report Cards Grid
            _buildReportCard(
              context: context,
              title: 'Feedback Report',
              description: 'Submit customer feedback and comments',
              icon: Icons.feedback,
              iconColor: Colors.purple,
              route: '/reports/feedback',
              features: ['Feedback Comment'],
              isCompact: isCompact,
              isCompleted: ref
                  .read(reportsNotifierProvider.notifier)
                  .isReportCompleted('FEEDBACK'),
            ),
            SizedBox(height: isCompact ? 12 : 16),

            _buildReportCard(
              context: context,
              title: 'Product Availability Report',
              description: 'Track product availability and stock levels',
              icon: Icons.inventory,
              iconColor: Colors.green,
              route: '/reports/product-availability',
              features: ['Product Name', 'Quantity'],
              isCompact: isCompact,
              isCompleted: ref
                  .read(reportsNotifierProvider.notifier)
                  .isReportCompleted('PRODUCT_AVAILABILITY'),
            ),
            SizedBox(height: isCompact ? 12 : 16),

            _buildReportCard(
              context: context,
              title: 'Visibility Activity Report',
              description: 'Record visibility and promotional activities',
              icon: Icons.visibility,
              iconColor: Colors.indigo,
              route: '/reports/visibility',
              features: ['Activity Description', 'Activity Photo'],
              isCompact: isCompact,
              isCompleted: ref
                  .read(reportsNotifierProvider.notifier)
                  .isReportCompleted('VISIBILITY_ACTIVITY'),
            ),
            SizedBox(height: isCompact ? 12 : 16),

            _buildReportCard(
              context: context,
              title: 'Share of Shelf Report',
              description: 'Track shelf space and market share analysis',
              icon: Icons.storefront,
              iconColor: Colors.blue,
              route: '/reports/show-of-shelf',
              features: [
                'Product Name',
                'Total Items on Shelf',
                'Company Items on Shelf'
              ],
              isCompact: isCompact,
              isCompleted: ref
                  .read(reportsNotifierProvider.notifier)
                  .isReportCompleted('SHOW_OF_SHELF'),
            ),
            SizedBox(height: isCompact ? 12 : 16),

            _buildReportCard(
              context: context,
              title: 'Product Expiry Report',
              description: 'Track product expiry dates and batch numbers',
              icon: Icons.schedule,
              iconColor: Colors.orange,
              route: '/reports/product-expiry',
              features: ['Product Name', 'Quantity', 'Expiry Date'],
              isCompact: isCompact,
              isCompleted: ref
                  .read(reportsNotifierProvider.notifier)
                  .isReportCompleted('PRODUCT_EXPIRY'),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            _buildActionButton(
              context: context,
              onPressed: () async {
                await _performCheckOut(context, ref, journeyPlanId);
              },
              icon: Icons.logout,
              label: 'Check Out Journey Plan',
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              isCompact: isCompact,
            ),
            SizedBox(height: isCompact ? 12 : 16),

            // _buildActionButton(
            //   context: context,
            //   onPressed: () {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(
            //         content: Text('Reports skipped'),
            //         backgroundColor: Colors.blue,
            //       ),
            //     );
            //     context.pop();
            //   },
            //   icon: Icons.skip_next,
            //   label: 'Skip Reports',
            //   backgroundColor: Colors.transparent,
            //   foregroundColor: Theme.of(context).colorScheme.primary,
            //   isOutlined: true,
            //   isCompact: isCompact,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required String route,
    required List<String> features,
    required bool isCompact,
    required bool isCompleted,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCompleted ? Colors.green : iconColor.withOpacity(0.2),
          width: isCompleted ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          context.push(
            route,
            extra: {
              'journeyPlanId': journeyPlanId,
              'clientId': clientId,
              'userId': userId,
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 16 : 20),
          child: Column(
            children: [
              // Icon and Title
              Row(
                children: [
                  Container(
                    width: isCompact ? 40 : 48,
                    height: isCompact ? 40 : 48,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green.withOpacity(0.1)
                          : iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isCompleted ? Icons.check_circle : icon,
                      size: isCompact ? 20 : 24,
                      color: isCompleted ? Colors.green : iconColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: isCompact ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            if (isCompleted)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isCompact ? 6 : 8,
                                  vertical: isCompact ? 2 : 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.green[200]!),
                                ),
                                child: Text(
                                  'Completed',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontSize: isCompact ? 10 : 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: isCompact ? 12 : 13,
                            color: Colors.grey[600],
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: isCompact ? 14 : 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Features
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isCompact ? 8 : 10),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green[50] : Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCompleted ? Colors.green[200]! : Colors.grey[200]!,
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: features
                      .map((feature) => Padding(
                            padding: EdgeInsets.only(bottom: isCompact ? 4 : 6),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: isCompleted
                                      ? Colors.green
                                      : Colors.grey[400],
                                  size: isCompact ? 12 : 14,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  feature,
                                  style: TextStyle(
                                    fontSize: isCompact ? 11 : 12,
                                    color: isCompleted
                                        ? Colors.green[700]
                                        : Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
    required bool isCompact,
    bool isOutlined = false,
  }) {
    return SizedBox(
      height: isCompact ? 44 : 50,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: isCompact ? 18 : 20),
              label: Text(
                label,
                style: TextStyle(fontSize: isCompact ? 14 : 16),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: foregroundColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: isCompact ? 18 : 20),
              label: Text(
                label,
                style: TextStyle(fontSize: isCompact ? 14 : 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
    );
  }
}
