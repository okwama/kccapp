import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/providers.dart';
import '../constants/app_colors.dart';
import '../services/location_service.dart';
import '../services/image_upload_service.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/journey_plans/presentation/pages/journey_plans_page.dart';
import '../../features/journey_plans/presentation/providers/journey_plans_providers.dart';
import '../../features/reports/presentation/pages/reports_selection_page.dart';
import '../../features/reports/presentation/pages/show_of_shelf_report_form.dart';
import '../../features/reports/presentation/pages/product_expiry_report_form.dart';
import '../../features/reports/presentation/pages/feedback_report_form.dart';
import '../../features/reports/presentation/pages/product_availability_report_form.dart';
import '../../features/reports/presentation/pages/visibility_report_form.dart';
import '../../features/clients/presentation/pages/clients_list_page.dart';
import '../../features/clients/presentation/pages/add_client_page.dart';
import '../../features/clients/presentation/pages/client_details_page.dart';
import '../../features/notices/presentation/pages/notices_page.dart';
import '../../features/notices/presentation/pages/notice_detail_page.dart';
import 'package:intl/intl.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      try {
        // Get the auth state from the provider
        final container = ProviderScope.containerOf(context);
        final authState = container.read(authProvider);

        // If still loading, don't redirect - let the current page load
        if (authState.isLoading) {
          return null;
        }

        // If not authenticated and not on login page, redirect to login
        if (!authState.isAuthenticated && state.matchedLocation != '/login') {
          return '/login';
        }

        // If authenticated and on login page, redirect to home
        if (authState.isAuthenticated && state.matchedLocation == '/login') {
          return '/';
        }

        return null;
      } catch (e) {
        // If there's an error accessing the provider, redirect to login
        if (state.matchedLocation != '/login') {
          return '/login';
        }
        return null;
      }
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/journey-plans',
        builder: (context, state) => const JourneyPlansPage(),
      ),
      GoRoute(
        path: '/journey-plans/:id',
        builder: (context, state) {
          final journeyPlanId = int.parse(state.pathParameters['id']!);
          return Consumer(
            builder: (context, ref, child) {
              final journeyPlansState = ref.watch(journeyPlansNotifierProvider);

              try {
                final journeyPlan = journeyPlansState.journeyPlans.firstWhere(
                  (plan) => plan.id == journeyPlanId,
                  orElse: () => throw Exception('Journey plan not found'),
                );
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Journey Plan Details'),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  body: LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxWidth < 600;
                      return SingleChildScrollView(
                        padding: EdgeInsets.all(isCompact ? 12 : 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status indicator header
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(isCompact ? 12 : 16),
                              decoration: BoxDecoration(
                                color: _getStatusColor(journeyPlan.status)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getStatusColor(journeyPlan.status)
                                      .withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: isCompact ? 40 : 48,
                                    height: isCompact ? 40 : 48,
                                    decoration: BoxDecoration(
                                      color:
                                          _getStatusColor(journeyPlan.status),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _getStatusIcon(journeyPlan.status),
                                      color: Colors.white,
                                      size: isCompact ? 20 : 24,
                                    ),
                                  ),
                                  SizedBox(width: isCompact ? 12 : 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _getStatusText(journeyPlan.status),
                                          style: TextStyle(
                                            fontSize: isCompact ? 16 : 18,
                                            fontWeight: FontWeight.bold,
                                            color: _getStatusColor(
                                                journeyPlan.status),
                                          ),
                                        ),
                                        Text(
                                          'Journey Plan Status',
                                          style: TextStyle(
                                            fontSize: isCompact ? 12 : 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: isCompact ? 16 : 20),

                            // Journey plan details card
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(isCompact ? 16 : 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Client info
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.business,
                                          size: isCompact ? 20 : 24,
                                          color: AppColors.primary,
                                        ),
                                        SizedBox(width: isCompact ? 8 : 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Client',
                                                style: TextStyle(
                                                  fontSize: isCompact ? 12 : 14,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                journeyPlan.client?.name ??
                                                    'Unknown',
                                                style: TextStyle(
                                                  fontSize: isCompact ? 16 : 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: isCompact ? 16 : 20),

                                    // Date and time info
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    size: isCompact ? 16 : 18,
                                                    color: Colors.grey[600],
                                                  ),
                                                  SizedBox(
                                                      width: isCompact ? 6 : 8),
                                                  Text(
                                                    'Date',
                                                    style: TextStyle(
                                                      fontSize:
                                                          isCompact ? 12 : 14,
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                DateFormat(
                                                        'EEEE, MMMM dd, yyyy')
                                                    .format(journeyPlan.date),
                                                style: TextStyle(
                                                  fontSize: isCompact ? 14 : 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    size: isCompact ? 16 : 18,
                                                    color: Colors.grey[600],
                                                  ),
                                                  SizedBox(
                                                      width: isCompact ? 6 : 8),
                                                  Text(
                                                    'Time',
                                                    style: TextStyle(
                                                      fontSize:
                                                          isCompact ? 12 : 14,
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                journeyPlan.time,
                                                style: TextStyle(
                                                  fontSize: isCompact ? 14 : 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Notes section
                                    if (journeyPlan.notes?.isNotEmpty ==
                                        true) ...[
                                      SizedBox(height: isCompact ? 16 : 20),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.note,
                                            size: isCompact ? 16 : 18,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(width: isCompact ? 6 : 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Notes',
                                                  style: TextStyle(
                                                    fontSize:
                                                        isCompact ? 12 : 14,
                                                    color: Colors.grey[600],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  journeyPlan.notes!,
                                                  style: TextStyle(
                                                    fontSize:
                                                        isCompact ? 14 : 16,
                                                    color: Colors.grey[700],
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: isCompact ? 20 : 24),

                            // Status-based action buttons
                            Consumer(
                              builder: (context, ref, child) {
                                return Column(
                                  children: [
                                    // Check-in button for pending status
                                    if (journeyPlan.status ==
                                        0) // Pending status
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          onPressed: () async {
                                            await _performCheckIn(
                                                context, ref, journeyPlan);
                                          },
                                          icon: const Icon(Icons.camera_alt),
                                          label: const Text('Check In'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                                vertical: isCompact ? 14 : 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),

                                    // Resume Visit and Check-out buttons for checked-in status
                                    if (journeyPlan.status ==
                                        1) // Checked-in status
                                      Column(
                                        children: [
                                          // Resume Visit button
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                // Navigate to reports selection page
                                                context.push(
                                                  '/reports/selection',
                                                  extra: {
                                                    'journeyPlanId':
                                                        journeyPlan.id,
                                                    'clientId':
                                                        journeyPlan.clientId,
                                                    'userId':
                                                        journeyPlan.userId,
                                                  },
                                                );
                                              },
                                              icon:
                                                  const Icon(Icons.assignment),
                                              label: const Text('Resume Visit'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primary,
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        isCompact ? 14 : 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: isCompact ? 12 : 16),
                                          // Check Out button
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton.icon(
                                              onPressed: () async {
                                                await _performCheckOut(
                                                    context, ref, journeyPlan);
                                              },
                                              icon: const Icon(Icons.logout),
                                              label: const Text('Check Out'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        isCompact ? 14 : 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                    // Status indicator for completed
                                    if (journeyPlan.status ==
                                        2) // Completed status
                                      Container(
                                        width: double.infinity,
                                        padding:
                                            EdgeInsets.all(isCompact ? 16 : 20),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.green.shade200),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.check_circle,
                                                color: Colors.green),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Visit Completed',
                                              style: TextStyle(
                                                color: Colors.green.shade700,
                                                fontWeight: FontWeight.bold,
                                                fontSize: isCompact ? 16 : 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } catch (e) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Journey Plan Not Found'),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  body: Center(
                    child:
                        Text('Journey plan with ID $journeyPlanId not found'),
                  ),
                );
              }
            },
          );
        },
      ),
      GoRoute(
        path: '/clients',
        builder: (context, state) => const ClientsListPage(),
      ),
      GoRoute(
        path: '/clients/add',
        builder: (context, state) => const AddClientPage(),
      ),
      GoRoute(
        path: '/clients/:id',
        builder: (context, state) {
          final clientId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return ClientDetailsPage(clientId: clientId);
        },
      ),
      GoRoute(
        path: '/notices',
        builder: (context, state) => const NoticesPage(),
      ),
      GoRoute(
        path: '/notices/:id',
        builder: (context, state) {
          final noticeId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return NoticeDetailPage(noticeId: noticeId);
        },
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Products Page')),
        ),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Orders Page')),
        ),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Reports Page')),
        ),
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Tasks Page')),
        ),
      ),
      GoRoute(
        path: '/analytics',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Analytics Page')),
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      // Report Routes
      GoRoute(
        path: '/reports/selection',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ReportsSelectionPage(
            journeyPlanId: extra?['journeyPlanId'],
            clientId: extra?['clientId'],
            userId: extra?['userId'],
          );
        },
      ),
      GoRoute(
        path: '/reports/show-of-shelf',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ShowOfShelfReportForm(
            journeyPlanId: extra?['journeyPlanId'],
            clientId: extra?['clientId'],
            userId: extra?['userId'],
          );
        },
      ),
      GoRoute(
        path: '/reports/product-expiry',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ProductExpiryReportForm(
            journeyPlanId: extra?['journeyPlanId'],
            clientId: extra?['clientId'],
            userId: extra?['userId'],
          );
        },
      ),
      GoRoute(
        path: '/reports/feedback',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return FeedbackReportForm(
            journeyPlanId: extra?['journeyPlanId'],
            clientId: extra?['clientId'],
            userId: extra?['userId'],
          );
        },
      ),
      GoRoute(
        path: '/reports/product-availability',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ProductAvailabilityReportForm(
            journeyPlanId: extra?['journeyPlanId'],
            clientId: extra?['clientId'],
            userId: extra?['userId'],
          );
        },
      ),
      GoRoute(
        path: '/reports/visibility',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return VisibilityReportForm(
            journeyPlanId: extra?['journeyPlanId'],
            clientId: extra?['clientId'],
            userId: extra?['userId'],
          );
        },
      ),
    ],
  );

  // Helper method for check-in process
  static Future<void> _performCheckIn(
    BuildContext context,
    WidgetRef ref,
    dynamic journeyPlan,
  ) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Get current location
      final locationResult = await LocationService.getCurrentLocation();

      if (!locationResult.isSuccess) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Using default location (Nairobi)'),
            backgroundColor: Colors.blue,
          ),
        );
      }

      // Capture photo
      final ImagePicker picker = ImagePicker();
      XFile? photo;

      try {
        photo = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
        );
      } catch (e) {
        // On web, camera might not be available, try gallery
        try {
          photo = await picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 80,
          );
        } catch (galleryError) {
          // If both fail, show error
          Navigator.of(context).pop(); // Close loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to access camera/gallery: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      Navigator.of(context).pop(); // Close loading

      if (photo != null) {
        // Upload image
        String? imageUrl;
        try {
          final apiClient = ref.read(apiClientProvider);
          final imageUploadService = ImageUploadService(apiClient.dio);
          imageUrl = await imageUploadService.uploadImage(photo);

          if (imageUrl == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Failed to upload image, but continuing with check-in'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        } catch (e) {
          print('❌ Image upload failed: $e');
          // Continue with check-in even if image upload fails
        }

        // Perform check-in
        await ref.read(journeyPlansNotifierProvider.notifier).checkIn(
              journeyPlan.id,
              latitude: locationResult.latitude,
              longitude: locationResult.longitude,
              imageUrl: imageUrl,
            );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully checked in!'),
            backgroundColor: Colors.green,
          ),
        );

        // Show reports selection page
        if (context.mounted) {
          context.push(
            '/reports/selection',
            extra: {
              'journeyPlanId': journeyPlan.id,
              'clientId': journeyPlan.clientId,
              'userId': journeyPlan.userId,
            },
          );
        }

        // Refresh the journey plans
        ref.read(journeyPlansNotifierProvider.notifier).loadJourneyPlans();
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to check in: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Helper method for check-out process
  static Future<void> _performCheckOut(
    BuildContext context,
    WidgetRef ref,
    dynamic journeyPlan,
  ) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Get current location
      final locationResult = await LocationService.getCurrentLocation();

      if (!locationResult.isSuccess) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Using default location (Nairobi)'),
            backgroundColor: Colors.blue,
          ),
        );
      }

      Navigator.of(context).pop(); // Close loading

      // Perform check-out
      await ref.read(journeyPlansNotifierProvider.notifier).checkOut(
            journeyPlan.id,
            latitude: locationResult.latitude,
            longitude: locationResult.longitude,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully checked out!'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the journey plans
      ref.read(journeyPlansNotifierProvider.notifier).loadJourneyPlans();
    } catch (e) {
      Navigator.of(context).pop(); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to check out: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return AppColors.primary; // Pending
      case 1:
        return AppColors.primary; // Checked-in
      case 2:
        return Colors.green; // Completed
      default:
        return Colors.grey;
    }
  }

  static IconData _getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icons.pending_actions; // Pending
      case 1:
        return Icons.check_circle; // Checked-in
      case 2:
        return Icons.check_circle; // Completed
      default:
        return Icons.info;
    }
  }

  static String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Checked In';
      case 2:
        return 'Completed';
      default:
        return 'Unknown Status';
    }
  }
}
