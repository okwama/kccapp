import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<LocationResult> getCurrentLocation() async {
    try {
      if (kIsWeb) {
        // Web implementation - use browser's geolocation API
        return await _getWebLocation();
      } else {
        // Mobile implementation - use geolocator plugin
        return await _getMobileLocation();
      }
    } catch (e) {
      print('❌ LocationService: Failed to get location: $e');
      return LocationResult.failure('Failed to get location: $e');
    }
  }

  static Future<LocationResult> _getMobileLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationResult.failure('Location services are disabled');
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationResult.failure('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return LocationResult.failure(
            'Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return LocationResult.success(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      return LocationResult.failure('Mobile location error: $e');
    }
  }

  static Future<LocationResult> _getWebLocation() async {
    try {
      // For web, we'll use a simple approach with default coordinates
      // In a real implementation, you'd use JavaScript interop for browser geolocation
      return LocationResult.success(
        latitude: -1.2921, // Default to Nairobi
        longitude: 36.8219,
        isDefault: true,
      );
    } catch (e) {
      return LocationResult.failure('Web location error: $e');
    }
  }
}

class LocationResult {
  final bool isSuccess;
  final double? latitude;
  final double? longitude;
  final String? error;
  final bool isDefault;

  LocationResult._({
    required this.isSuccess,
    this.latitude,
    this.longitude,
    this.error,
    this.isDefault = false,
  });

  factory LocationResult.success({
    required double latitude,
    required double longitude,
    bool isDefault = false,
  }) {
    return LocationResult._(
      isSuccess: true,
      latitude: latitude,
      longitude: longitude,
      isDefault: isDefault,
    );
  }

  factory LocationResult.failure(String error) {
    return LocationResult._(
      isSuccess: false,
      error: error,
    );
  }
}
