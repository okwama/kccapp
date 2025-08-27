import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadService {
  final Dio _dio;

  ImageUploadService(this._dio);

  Future<String?> uploadImage(XFile imageFile) async {
    try {
      // Convert XFile to File
      final file = File(imageFile.path);

      // Create form data
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: 'checkin_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
        'type': 'journey_plan_checkin',
      });

      // Upload to server
      final response = await _dio.post('/uploads/upload', data: formData);

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['url'] as String?;
      }

      return null;
    } catch (e) {
      print('❌ ImageUploadService: Failed to upload image: $e');
      return null;
    }
  }

  Future<String?> uploadImageFromBytes(
      List<int> imageBytes, String filename) async {
    try {
      // Create form data from bytes
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          imageBytes,
          filename: filename,
        ),
        'type': 'journey_plan_checkin',
      });

      // Upload to server
      final response = await _dio.post('/uploads/upload', data: formData);

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['url'] as String?;
      }

      return null;
    } catch (e) {
      print('❌ ImageUploadService: Failed to upload image from bytes: $e');
      return null;
    }
  }
}
