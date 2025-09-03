import 'package:hive_flutter/hive_flutter.dart';
import 'local_storage.dart';
import 'client_storage.dart';
import 'product_storage.dart';

class StorageService {
  static bool _isInitialized = false;
  
  /// Initialize all storage systems
  static Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      // Initialize Hive
      await Hive.initFlutter();
      
      // Initialize basic local storage
      await LocalStorage.init();
      
      // Initialize client storage
      await ClientStorage.init();
      
      // Initialize product storage
      await ProductStorage.init();
      
      _isInitialized = true;
      print('✅ Storage service initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize storage service: $e');
      rethrow;
    }
  }
  
  /// Check if storage is initialized
  static bool get isInitialized => _isInitialized;
  
  /// Get storage statistics
  static Map<String, dynamic> getStorageStats() {
    if (!_isInitialized) {
      return {'error': 'Storage not initialized'};
    }
    
    try {
      return {
        'localStorage': LocalStorage.getUser() != null ? 'Has user data' : 'No user data',
        'clientStorage': ClientStorage.getStorageStats(),
        'productStorage': ProductStorage.getStorageStats(),
        'hiveBoxes': _getHiveBoxStats(),
      };
    } catch (e) {
      return {'error': 'Failed to get storage stats: $e'};
    }
  }
  
  /// Get Hive box statistics
  static Map<String, dynamic> _getHiveBoxStats() {
    try {
      final stats = <String, dynamic>{};
      
      // Get stats for known boxes
      try {
        final clientBox = Hive.box('clients');
        if (clientBox.isOpen) {
          stats['clients'] = {
            'length': clientBox.length,
            'isOpen': clientBox.isOpen,
            'isEmpty': clientBox.isEmpty,
          };
        }
      } catch (e) {
        stats['clients'] = {'error': 'Box not open'};
      }
      
      try {
        final productBox = Hive.box('products');
        if (productBox.isOpen) {
          stats['products'] = {
            'length': productBox.length,
            'isOpen': productBox.isOpen,
            'isEmpty': productBox.isEmpty,
          };
        }
      } catch (e) {
        stats['products'] = {'error': 'Box not open'};
      }
      
      try {
        final appBox = Hive.box('kcc_app');
        if (appBox.isOpen) {
          stats['kcc_app'] = {
            'length': appBox.length,
            'isOpen': appBox.isOpen,
            'isEmpty': appBox.isEmpty,
          };
        }
      } catch (e) {
        stats['kcc_app'] = {'error': 'Box not open'};
      }
      
      return stats;
    } catch (e) {
      return {'error': 'Failed to get Hive box stats: $e'};
    }
  }
  
  /// Clear all storage data
  static Future<void> clearAllData() async {
    if (!_isInitialized) return;
    
    try {
      await LocalStorage.clearAll();
      await ClientStorage.clearAll();
      await ProductStorage.clearAll();
      print('✅ All storage data cleared');
    } catch (e) {
      print('❌ Failed to clear storage data: $e');
      rethrow;
    }
  }
  
  /// Close all storage connections
  static Future<void> close() async {
    if (!_isInitialized) return;
    
    try {
      await ClientStorage.close();
      await ProductStorage.close();
      _isInitialized = false;
      print('✅ Storage service closed');
    } catch (e) {
      print('❌ Failed to close storage service: $e');
      rethrow;
    }
  }
  
  /// Perform storage maintenance
  static Future<void> performMaintenance() async {
    if (!_isInitialized) return;
    
    try {
      // Compact known boxes
      try {
        final clientBox = Hive.box('clients');
        if (clientBox.isOpen) {
          await clientBox.compact();
        }
      } catch (e) {
        // Box not open, skip
      }
      
      try {
        final productBox = Hive.box('products');
        if (productBox.isOpen) {
          await productBox.compact();
        }
      } catch (e) {
        // Box not open, skip
      }
      
      try {
        final appBox = Hive.box('kcc_app');
        if (appBox.isOpen) {
          await appBox.compact();
        }
      } catch (e) {
        // Box not open, skip
      }
      
      print('✅ Storage maintenance completed');
    } catch (e) {
      print('❌ Storage maintenance failed: $e');
      rethrow;
    }
  }
}
