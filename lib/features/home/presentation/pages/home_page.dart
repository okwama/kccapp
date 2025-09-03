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
import '../../../notices/presentation/providers/notices_providers.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState.isAuthenticated && authState.user != null) {
        ref
            .read(clockInOutNotifierProvider.notifier)
            .loadClockStatus(authState.user!.id);

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

        final currentClockState = ref.read(clockInOutNotifierProvider);
        if (currentClockState.status.isClockedIn &&
            currentClockState.status.currentSession != null) {
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
        setState(() {});
      } else {
        timer.cancel();
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
    final authState = ref.read(authProvider);
    if (authState.isAuthenticated && authState.user != null) {
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
      return clockState.status.currentSession!.formattedDuration;
    }
    return '--:--';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final clientsState = ref.watch(clientsNotifierProvider);
    final journeyPlansState = ref.watch(journeyPlansNotifierProvider);
    final clockInOutState = ref.watch(clockInOutNotifierProvider);
    final noticesState = ref.watch(noticesNotifierProvider);

    ref.listen(clockInOutNotifierProvider, (previous, next) {
      if (previous?.status.isClockedIn != next.status.isClockedIn) {
        if (next.status.isClockedIn && next.status.currentSession != null) {
          _startDurationUpdates();
        } else {
          _durationUpdateTimer?.cancel();
        }
      }
    });

    ref.listen(authProvider, (previous, next) {
      if (next.isAuthenticated && (previous?.isAuthenticated != true)) {
        Future.microtask(() {
          ref.read(clientsNotifierProvider.notifier).loadClients();
          ref.read(journeyPlansNotifierProvider.notifier).loadJourneyPlans();
          ref.read(noticesNotifierProvider.notifier).loadNotices(
                countryId:
                    next.user!.countryId > 0 ? next.user!.countryId : null,
              );
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
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
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
                await Future.wait([
                  ref
                      .read(clockInOutNotifierProvider.notifier)
                      .loadClockStatus(authState.user!.id),
                  ref.read(clientsNotifierProvider.notifier).loadClients(),
                  ref
                      .read(journeyPlansNotifierProvider.notifier)
                      .loadJourneyPlans(),
                  ref.read(noticesNotifierProvider.notifier).loadNotices(
                        countryId: authState.user!.countryId > 0
                            ? authState.user!.countryId
                            : null,
                      ),
                ]);
              }
            },
            child: Column(
              children: [
                // Welcome Section
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Text(
                    'Welcome, ${user?.name?.split(' ').first ?? 'Sales Rep'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Menu Grid - Full Height
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quick Actions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.2,
                              children: [
                                // Clock In/Out
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: clockInOutState.status.isClockedIn
                                          ? AppColors.success
                                          : AppColors.primary,
                                      width: 1.5,
                                    ),
                                    color: clockInOutState.status.isClockedIn
                                        ? AppColors.success.withOpacity(0.05)
                                        : AppColors.primary.withOpacity(0.05),
                                  ),
                                  child: MenuTile(
                                    title: clockInOutState.status.isClockedIn
                                        ? 'Clock Out'
                                        : 'Clock In',
                                    icon: clockInOutState.status.isClockedIn
                                        ? Icons.logout_rounded
                                        : Icons.login_rounded,
                                    onTap: () => _showClockConfirmationDialog(
                                        context, ref, user!.id),
                                    subtitle: clockInOutState.status.isClockedIn
                                        ? 'End session'
                                        : 'Start session',
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

                                // Journey Plans
                                MenuTile(
                                  title: 'Journey Plans',
                                  icon: Icons.map_rounded,
                                  onTap: () => context.push('/journey-plans'),
                                  badgeCount:
                                      journeyPlansState.journeyPlans.length,
                                  subtitle: 'Route planning',
                                ),

                                // Clients
                                MenuTile(
                                  title: 'Clients',
                                  icon: Icons.people_rounded,
                                  onTap: () => context.push('/clients'),
                                  badgeCount: clientsState.clients.length,
                                  subtitle: 'Manage clients',
                                ),

                                // Notices
                                MenuTile(
                                  title: 'Notices',
                                  icon: Icons.notifications_rounded,
                                  onTap: () => context.push('/notices'),
                                  badgeCount: noticesState.notices.length,
                                  subtitle: 'Announcements',
                                ),

                                // Profile
                                MenuTile(
                                  title: 'Profile',
                                  icon: Icons.person_rounded,
                                  onTap: () => context.push('/profile'),
                                  subtitle: 'Settings',
                                ),
                              ],
                            ),
                          ),

                          // Footer at bottom
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: AppColors.success,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Powered by CitlogisticsSystems',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isClockedIn ? AppColors.error : AppColors.success)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isClockedIn ? Icons.logout_rounded : Icons.login_rounded,
                  color: isClockedIn ? AppColors.error : AppColors.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isClockedIn ? 'Clock Out' : 'Clock In',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
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
                    ? 'End your work session?'
                    : 'Start your work session?',
                style: const TextStyle(fontSize: 15),
              ),
              if (isClockedIn && clockState.status.currentSession != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: AppColors.success,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Session: ${_getCurrentDuration()}',
                        style: TextStyle(
                          fontSize: 13,
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
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
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
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                elevation: 0,
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
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                const Text('Successfully clocked out!'),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } else {
      success = await clockNotifier.clockIn(userId);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                const Text('Successfully clocked in!'),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }

    if (!success && context.mounted) {
      final error =
          ref.read(clockInOutNotifierProvider).error ?? 'Operation failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(error)),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
