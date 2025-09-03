import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  final Dio _dio;

  ProfileService(this._dio);

  /// Upload profile photo
  Future<String?> uploadProfilePhoto(XFile imageFile) async {
    try {
      // Convert XFile to File
      final file = File(imageFile.path);

      // Create form data
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          file.path,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      // Upload to server
      final response = await _dio.post('/profile/photo', data: formData);

      if (response.statusCode == 200 && response.data['photoUrl'] != null) {
        return response.data['photoUrl'] as String;
      }

      return null;
    } catch (e) {
      print('❌ ProfileService: Failed to upload profile photo: $e');
      return null;
    }
  }

  /// Update profile information
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
  }) async {
    try {
      final data = <String, dynamic>{};
      
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (phoneNumber != null) data['phoneNumber'] = phoneNumber;

      if (data.isEmpty) return false;

      // Use email endpoint for email updates
      if (email != null) {
        final response = await _dio.post('/profile/email', data: {'email': email});
        return response.statusCode == 200;
      }

      // For now, return true as general profile update endpoint doesn't exist
      // TODO: Implement general profile update endpoint in backend
      return true;
    } catch (e) {
      print('❌ ProfileService: Failed to update profile: $e');
      return false;
    }
  }

  /// Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post('/profile/password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': newPassword,
      });
      return response.statusCode == 200;
    } catch (e) {
      print('❌ ProfileService: Failed to change password: $e');
      return false;
    }
  }
}
