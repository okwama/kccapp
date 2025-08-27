import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static const String _boxName = 'kcc_app';
  static late Box _box;
  
  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }
  
  static Future<void> saveToken(String token) async {
    await _box.put('auth_token', token);
  }
  
  static String? getToken() {
    return _box.get('auth_token');
  }
  
  static Future<void> removeToken() async {
    await _box.delete('auth_token');
  }
  
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _box.put('user', user);
  }
  
  static Map<String, dynamic>? getUser() {
    return _box.get('user');
  }
  
  static Future<void> removeUser() async {
    await _box.delete('user');
  }
  
  static Future<void> clearAll() async {
    await _box.clear();
  }
}
