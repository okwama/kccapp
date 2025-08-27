import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/menu_tile.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/providers.dart';
import '../../../clients/presentation/providers/clients_providers.dart';
import '../../../journey_plans/presentation/providers/journey_plans_providers.dart';
import '../../../clock_in_out/presentation/providers/clock_in_out_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Timer? _statusRefreshTimer;
  Timer? _durationUpdateTimer;

  @override
  void initState() {
    super.initState();
    // Load clock status when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState.isAuthenticated && authState.user != null) {
        print(
            '🔄 HomePage: Loading clock status on init for user ${authState.user!.id}');
        ref
            .read(clockInOutNotifierProvider.notifier)
            .loadClockStatus(authState.user!.id);

        // Start periodic refresh for status updates (less frequent since we use real-time duration)
        _statusRefreshTimer =
            Timer.periodic(const Duration(minutes: 5), (timer) {
          final currentAuthState = ref.read(authProvider);
          if (currentAuthState.isAuthenticated &&
              currentAuthState.user != null) {
            ref
                .read(clockInOutNotifierProvider.notifier)
                .loadClockStatus(currentAuthState.user!.id);
          }
        });

        // Check if user is already clocked in and start duration updates
        final currentClockState = ref.read(clockInOutNotifierProvider);
        if (currentClockState.status.isClockedIn &&
            currentClockState.status.currentSession != null) {
          print(
              '🔄 HomePage: User already clocked in, starting duration updates');
          _startDurationUpdates();
        }
      }
    });
  }

  void _startDurationUpdates() {
    _durationUpdateTimer?.cancel();
    _durationUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final clockState = ref.read(clockInOutNotifierProvider);
      if (clockState.status.isClockedIn &&
          clockState.status.currentSession != null) {
        // Force UI rebuild to update duration display using session start time
        setState(() {});
        print(
            '🔄 Duration update: ${clockState.status.currentSession!.formattedDuration}');
      } else {
        // Stop timer if not clocked in
        timer.cancel();
        print('🔄 Stopping duration updates - user not clocked in');
      }
    });
  }

  @override
  void dispose() {
    _statusRefreshTimer?.cancel();
    _durationUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh status when dependencies change (e.g., when returning to this page)
    final authState = ref.read(authProvider);
    if (authState.isAuthenticated && authState.user != null) {
      print(
          '🔄 HomePage: Refreshing clock status on dependency change for user ${authState.user!.id}');
      // Use Future.microtask to avoid modifying provider during build
      Future.microtask(() {
        ref
            .read(clockInOutNotifierProvider.notifier)
            .loadClockStatus(authState.user!.id);
      });
    }
  }

  String _getCurrentDuration() {
    final clockState = ref.read(clockInOutNotifierProvider);
    if (clockState.status.isClockedIn &&
        clockState.status.currentSession != null) {
      final session = clockState.status.currentSession!;
      print(
          '🔍 Duration Debug - Session ID: ${session.id}, Status: ${session.status}, Start: ${session.sessionStart}, IsActive: ${session.isActive}');
      final duration = session.formattedDuration;
      print('🔍 Duration Debug - Calculated duration: $duration');
      return duration;
    }
    print('🔍 Duration Debug - No active session found');
    return '--:--';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    // Watch real data from API providers
    final clientsState = ref.watch(clientsNotifierProvider);
    final journeyPlansState = ref.watch(journeyPlansNotifierProvider);
    final clockInOutState = ref.watch(clockInOutNotifierProvider);

    // Debug: Print current clock status
    print(
        '🔄 HomePage: Current clock status - isClockedIn: ${clockInOutState.status.isClockedIn}, isLoading: ${clockInOutState.isLoading}');

    // Listen for clock status changes to manage duration updates
    ref.listen(clockInOutNotifierProvider, (previous, next) {
      if (previous?.status.isClockedIn != next.status.isClockedIn) {
        if (next.status.isClockedIn && next.status.currentSession != null) {
          print(
              '🔄 HomePage: Starting duration updates - user clocked in at ${next.status.currentSession!.sessionStart}');
          _startDurationUpdates();
        } else {
          print('🔄 HomePage: Stopping duration updates - user clocked out');
          _durationUpdateTimer?.cancel();
        }
      }
    });

    // Load data on first build
    ref.listen(authProvider, (previous, next) {
      if (next.isAuthenticated && (previous?.isAuthenticated != true)) {
        // Load data when user becomes authenticated
        Future.microtask(() {
          print('🔄 HomePage: Loading data for user ${next.user!.id}');
          ref.read(clientsNotifierProvider.notifier).loadClients();
          ref.read(journeyPlansNotifierProvider.notifier).loadJourneyPlans();
          print('🔄 HomePage: Loading clock status for user ${next.user!.id}');
          ref
              .read(clockInOutNotifierProvider.notifier)
              .loadClockStatus(next.user!.id);
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('KCC Sales'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.push('/profile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryLight],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              final authState = ref.read(authProvider);
              if (authState.isAuthenticated && authState.user != null) {
                print(
                    '🔄 HomePage: Manual refresh triggered for user ${authState.user!.id}');
                await ref
                    .read(clockInOutNotifierProvider.notifier)
                    .loadClockStatus(authState.user!.id);
                await ref.read(clientsNotifierProvider.notifier).loadClients();
                await ref
                    .read(journeyPlansNotifierProvider.notifier)
                    .loadJourneyPlans();
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Sales Rep Name Section
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    child: Center(
                      child: Text(
                        user?.name ?? 'Sales Representative',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Menu Grid
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quick Actions',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.1,
                              children: [
                                // Clock In/Out (Implemented)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: clockInOutState.status.isClockedIn
                                          ? AppColors.success
                                          : AppColors.primary,
                                      width: 2,
                                    ),
                                    color: clockInOutState.status.isClockedIn
                                        ? AppColors.success.withOpacity(0.1)
                                        : Colors.white,
                                  ),
                                  child: MenuTile(
                                    title: clockInOutState.status.isClockedIn
                                        ? 'Clock Out'
                                        : 'Clock In',
                                    icon: clockInOutState.status.isClockedIn
                                        ? Icons.logout
                                        : Icons.login,
                                    onTap: () => _showClockConfirmationDialog(
                                        context, ref, user!.id),
                                    subtitle: clockInOutState.status.isClockedIn
                                        ? 'End work session'
                                        : 'Start work session',
                                    isLoading: clockInOutState.isClockingIn ||
                                        clockInOutState.isClockingOut,
                                    badgeText:
                                        clockInOutState.status.isClockedIn &&
                                                clockInOutState.status
                                                        .currentSession !=
                                                    null
                                            ? _getCurrentDuration()
                                            : null,
                                  ),
                                ),

                                // Journey Plans (Implemented)
                                MenuTile(
                                  title: 'Journey Plans',
                                  icon: Icons.map,
                                  onTap: () => context.push('/journey-plans'),
                                  badgeCount:
                                      journeyPlansState.journeyPlans.length,
                                  subtitle: 'Route planning',
                                ),

                                // Clients (Implemented)
                                MenuTile(
                                  title: 'Clients',
                                  icon: Icons.people,
                                  onTap: () => context.push('/clients'),
                                  badgeCount: clientsState.clients.length,
                                  subtitle: 'Manage clients',
                                ),

                                // Notices (Implemented)
                                MenuTile(
                                  title: 'Notices',
                                  icon: Icons.notifications,
                                  onTap: () => context.push('/notices'),
                                  subtitle: 'View announcements',
                                ),

                                // Profile (Implemented)
                                MenuTile(
                                  title: 'Profile',
                                  icon: Icons.person,
                                  onTap: () => context.push('/profile'),
                                  subtitle: 'User settings',
                                ),

                                // COMMENTED OUT - NOT YET IMPLEMENTED
                                // // Dashboard
                                // MenuTile(
                                //   title: 'Dashboard',
                                //   icon: Icons.dashboard,
                                //   onTap: () => context.push('/dashboard'),
                                //   subtitle: 'View overview',
                                // ),

                                // // Products
                                // MenuTile(
                                //   title: 'Products',
                                //   icon: Icons.inventory,
                                //   onTap: () => context.push('/products'),
                                //   subtitle: 'Product catalog',
                                // ),

                                // // Orders
                                // MenuTile(
                                //   title: 'Orders',
                                //   icon: Icons.shopping_cart,
                                //   onTap: () => context.push('/orders'),
                                //   subtitle: 'Process orders',
                                // ),

                                // // Tasks
                                // MenuTile(
                                //   title: 'Tasks',
                                //   icon: Icons.task,
                                //   onTap: () => context.push('/tasks'),
                                //   subtitle: 'Manage tasks',
                                // ),

                                // // Analytics
                                // MenuTile(
                                //   title: 'Analytics',
                                //   icon: Icons.trending_up,
                                //   onTap: () => context.push('/analytics'),
                                //   subtitle: 'Performance metrics',
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showClockConfirmationDialog(
      BuildContext context, WidgetRef ref, int userId) {
    final clockState = ref.read(clockInOutNotifierProvider);
    final isClockedIn = clockState.status.isClockedIn;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                isClockedIn ? Icons.logout : Icons.login,
                color: isClockedIn ? AppColors.error : AppColors.success,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isClockedIn ? 'Clock Out' : 'Clock In',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isClockedIn
                    ? 'Are you sure you want to end your work session?'
                    : 'Are you sure you want to start your work session?',
                style: const TextStyle(fontSize: 16),
              ),
              if (isClockedIn && clockState.status.currentSession != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.3),
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
                        'Current session: ${_getCurrentDuration()}',
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleClockAction(context, ref, userId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isClockedIn ? AppColors.error : AppColors.success,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isClockedIn ? 'Clock Out' : 'Clock In',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleClockAction(
      BuildContext context, WidgetRef ref, int userId) async {
    final clockNotifier = ref.read(clockInOutNotifierProvider.notifier);
    final clockState = ref.read(clockInOutNotifierProvider);

    bool success;
    if (clockState.status.isClockedIn) {
      success = await clockNotifier.clockOut(userId);
      if (success && context.mounted) {
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
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Successfully clocked in!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    if (!success && context.mounted) {
      final error =
          ref.read(clockInOutNotifierProvider).error ?? 'Operation failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
