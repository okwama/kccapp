import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final profileState = ref.watch(profileNotifierProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with gradient
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.logout, size: 20),
                  ),
                  onPressed: () => _showLogoutDialog(context, ref),
                ),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.grey[50]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              // Profile Photo
                              GestureDetector(
                                onTap: () => _showPhotoOptions(context, ref),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.primary,
                                        AppColors.primaryDark,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            AppColors.primary.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        _getProfileImage(user?.photoUrl),
                                    child: user?.photoUrl == null
                                        ? Text(
                                            user?.name
                                                    .substring(0, 1)
                                                    .toUpperCase() ??
                                                'U',
                                            style: const TextStyle(
                                              fontSize: 48,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),

                              // Photo Upload Indicator
                              if (profileState.isUploading)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  ),
                                ),

                              // Status Indicator
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: user?.status == 1
                                        ? AppColors.success
                                        : AppColors.error,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 3),
                                  ),
                                  child: Icon(
                                    user?.status == 1
                                        ? Icons.check
                                        : Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),

                              // Camera Icon for Photo Upload
                              Positioned(
                                bottom: 5,
                                left: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 3),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            user?.name ?? 'User Name',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              user?.role ?? 'Sales Representative',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: user?.status == 1
                                  ? AppColors.success.withOpacity(0.1)
                                  : AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  user?.status == 1
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  size: 16,
                                  color: user?.status == 1
                                      ? AppColors.success
                                      : AppColors.error,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  user?.status == 1 ? 'Active' : 'Inactive',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: user?.status == 1
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // User Information Section
                  _buildSectionHeader(
                      'Personal Information', Icons.person_outline),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildModernInfoTile(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: user?.email ?? 'N/A',
                          color: AppColors.info,
                        ),
                        _buildDivider(),
                        _buildModernInfoTile(
                          icon: Icons.phone_outlined,
                          label: 'Phone',
                          value: user?.phoneNumber ?? 'N/A',
                          color: AppColors.success,
                        ),
                        _buildDivider(),
                        _buildModernInfoTile(
                          icon: Icons.badge_outlined,
                          label: 'Employee ID',
                          value: user?.id.toString() ?? 'N/A',
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Work Information Section
                  _buildSectionHeader('Work Information', Icons.work_outline),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildModernInfoTile(
                          icon: Icons.business_center_outlined,
                          label: 'Role',
                          value: user?.role ?? 'N/A',
                          color: AppColors.primary,
                        ),
                        _buildDivider(),
                        _buildModernInfoTile(
                          icon: Icons.location_on_outlined,
                          label: 'Region',
                          value: 'Region ${user?.regionId ?? 'N/A'}',
                          color: AppColors.warning,
                        ),
                        _buildDivider(),
                        _buildModernInfoTile(
                          icon: Icons.route_outlined,
                          label: 'Route',
                          value: 'Route ${user?.routeId ?? 'N/A'}',
                          color: AppColors.info,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Quick Actions Section
                  _buildSectionHeader('Quick Actions', Icons.flash_on_outlined),
                  const SizedBox(height: 16),

                  // Action Cards Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: [
                      _buildActionCard(
                        icon: Icons.edit_outlined,
                        title: 'Edit Profile',
                        subtitle: 'Update info',
                        color: AppColors.primary,
                        onTap: () => _showEditProfileDialog(context, ref, user),
                      ),
                      _buildActionCard(
                        icon: Icons.lock_outline,
                        title: 'Security',
                        subtitle: 'Change password',
                        color: AppColors.warning,
                        onTap: () => _showChangePasswordDialog(context, ref),
                      ),
                      _buildActionCard(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        subtitle: 'App preferences',
                        color: AppColors.info,
                        onTap: () {
                          // TODO: Navigate to settings
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.help_outline,
                        title: 'Help',
                        subtitle: 'Support center',
                        color: AppColors.success,
                        onTap: () {
                          // TODO: Navigate to help
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Logout Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.error.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _showLogoutDialog(context, ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildModernInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      color: Colors.grey[200],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider? _getProfileImage(String? photoUrl) {
    if (photoUrl == null || photoUrl.isEmpty) return null;
    try {
      return NetworkImage(photoUrl);
    } catch (e) {
      print('❌ Error loading profile image: $e');
      return null;
    }
  }

  void _showPhotoOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Update Profile Photo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                ref.read(profileNotifierProvider.notifier).uploadProfilePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _capturePhotoFromCamera(ref);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _capturePhotoFromCamera(WidgetRef ref) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (photo != null) {
        await ref.read(profileNotifierProvider.notifier).uploadProfilePhoto();
      }
    } catch (e) {
      print('❌ Error capturing photo: $e');
    }
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, user) {
    final nameController = TextEditingController(text: user?.name);
    final emailController = TextEditingController(text: user?.email);
    final phoneController = TextEditingController(text: user?.phoneNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await ref
                  .read(profileNotifierProvider.notifier)
                  .updateProfile(
                    name: nameController.text,
                    email: emailController.text,
                    phoneNumber: phoneController.text,
                  );

              if (success && context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Profile updated successfully!')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New passwords do not match!')),
                );
                return;
              }

              final success = await ref
                  .read(profileNotifierProvider.notifier)
                  .changePassword(
                    currentPassword: currentPasswordController.text,
                    newPassword: newPasswordController.text,
                  );

              if (success && context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Password changed successfully!')),
                );
              }
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.logout,
              color: AppColors.error,
            ),
            const SizedBox(width: 8),
            const Text('Sign Out'),
          ],
        ),
        content: const Text(
          'Are you sure you want to sign out of your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
