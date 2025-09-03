import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/profile_service.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/models/auth_models.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileService _profileService;

  ProfileNotifier(this._profileService) : super(const ProfileState());

  /// Upload profile photo from gallery
  Future<bool> uploadProfilePhoto() async {
    try {
      state = state.copyWith(isUploading: true, error: null);

      // Pick image from gallery
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image == null) {
        state = state.copyWith(isUploading: false);
        return false;
      }

      // Upload to server
      final photoUrl = await _profileService.uploadProfilePhoto(image);

      if (photoUrl != null) {
        state = state.copyWith(
          isUploading: false,
          photoUrl: photoUrl,
        );
        return true;
      } else {
        state = state.copyWith(
          isUploading: false,
          error: 'Failed to upload photo',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: 'Error uploading photo: $e',
      );
      return false;
    }
  }

  /// Upload profile photo from camera
  Future<bool> uploadProfilePhotoFromCamera() async {
    try {
      state = state.copyWith(isUploading: true, error: null);

      // Pick image from camera
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image == null) {
        state = state.copyWith(isUploading: false);
        return false;
      }

      // Upload to server
      final photoUrl = await _profileService.uploadProfilePhoto(image);

      if (photoUrl != null) {
        state = state.copyWith(
          isUploading: false,
          photoUrl: photoUrl,
        );
        return true;
      } else {
        state = state.copyWith(
          isUploading: false,
          error: 'Failed to upload photo',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: 'Error uploading photo: $e',
      );
      return false;
    }
  }

  /// Update profile information
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
  }) async {
    try {
      state = state.copyWith(isUpdating: true, error: null);

      final success = await _profileService.updateProfile(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
      );

      if (success) {
        state = state.copyWith(
          isUpdating: false,
          updatedFields: {
            if (name != null) 'name': name,
            if (email != null) 'email': email,
            if (phoneNumber != null) 'phoneNumber': phoneNumber,
          },
        );
        return true;
      } else {
        state = state.copyWith(
          isUpdating: false,
          error: 'Failed to update profile',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: 'Error updating profile: $e',
      );
      return false;
    }
  }

  /// Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      state = state.copyWith(isChangingPassword: true, error: null);

      final success = await _profileService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (success) {
        state = state.copyWith(
          isChangingPassword: false,
          passwordChanged: true,
        );
        return true;
      } else {
        state = state.copyWith(
          isChangingPassword: false,
          error: 'Failed to change password',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isChangingPassword: false,
        error: 'Error changing password: $e',
      );
      return false;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Clear password changed status
  void clearPasswordChanged() {
    state = state.copyWith(passwordChanged: false);
  }
}

class ProfileState {
  final bool isUploading;
  final bool isUpdating;
  final bool isChangingPassword;
  final String? error;
  final String? photoUrl;
  final Map<String, String> updatedFields;
  final bool passwordChanged;

  const ProfileState({
    this.isUploading = false,
    this.isUpdating = false,
    this.isChangingPassword = false,
    this.error,
    this.photoUrl,
    this.updatedFields = const {},
    this.passwordChanged = false,
  });

  ProfileState copyWith({
    bool? isUploading,
    bool? isUpdating,
    bool? isChangingPassword,
    String? error,
    String? photoUrl,
    Map<String, String>? updatedFields,
    bool? passwordChanged,
  }) {
    return ProfileState(
      isUploading: isUploading ?? this.isUploading,
      isUpdating: isUpdating ?? this.isUpdating,
      isChangingPassword: isChangingPassword ?? this.isChangingPassword,
      error: error ?? this.error,
      photoUrl: photoUrl ?? this.photoUrl,
      updatedFields: updatedFields ?? this.updatedFields,
      passwordChanged: passwordChanged ?? this.passwordChanged,
    );
  }
}

// Providers
final profileServiceProvider = Provider<ProfileService>((ref) {
  final dio = ref.watch(apiClientProvider).dio;
  return ProfileService(dio);
});

final profileNotifierProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final profileService = ref.watch(profileServiceProvider);
  return ProfileNotifier(profileService);
});
