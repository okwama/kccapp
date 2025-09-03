import 'package:hive_flutter/hive_flutter.dart';
import '../../features/clients/data/models/client_model.dart';

class ClientStorage {
  static const String _boxName = 'clients';
  static late Box<ClientModel> _box;
  
  /// Initialize the client storage
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ClientModelAdapter());
    _box = await Hive.openBox<ClientModel>(_boxName);
  }
  
  /// Store multiple clients (overwrites existing data)
  static Future<void> storeClients(List<ClientModel> clients) async {
    await _box.clear(); // Clear existing data
    for (final client in clients) {
      await _box.put(client.id, client);
    }
  }
  
  /// Store a single client
  static Future<void> storeClient(ClientModel client) async {
    await _box.put(client.id, client);
  }
  
  /// Get all clients
  static List<ClientModel> getAllClients() {
    return _box.values.toList();
  }
  
  /// Get client by ID
  static ClientModel? getClientById(int id) {
    return _box.get(id);
  }
  
  /// Search clients by name or contact
  static List<ClientModel> searchClients(String query) {
    if (query.isEmpty) return getAllClients();
    
    final lowercaseQuery = query.toLowerCase();
    return _box.values
        .where((client) => 
            client.name.toLowerCase().contains(lowercaseQuery) ||
            (client.contact?.toLowerCase().contains(lowercaseQuery) ?? false))
        .toList();
  }
  
  /// Get clients by region
  static List<ClientModel> getClientsByRegion(int regionId) {
    return _box.values
        .where((client) => client.regionId == regionId)
        .toList();
  }
  
  /// Get clients by route
  static List<ClientModel> getClientsByRoute(int routeId) {
    return _box.values
        .where((client) => client.routeId == routeId)
        .toList();
  }
  
  /// Get clients by status
  static List<ClientModel> getClientsByStatus(int status) {
    return _box.values
        .where((client) => client.status == status)
        .toList();
  }
  
  /// Update client
  static Future<void> updateClient(ClientModel client) async {
    await _box.put(client.id, client);
  }
  
  /// Delete client
  static Future<void> deleteClient(int id) async {
    await _box.delete(id);
  }
  
  /// Get client count
  static int getClientCount() {
    return _box.length;
  }
  
  /// Check if client exists
  static bool clientExists(int id) {
    return _box.containsKey(id);
  }
  
  /// Get clients with pagination
  static List<ClientModel> getClientsPaginated({
    required int page,
    required int limit,
    String? search,
    int? regionId,
    int? routeId,
    int? status,
  }) {
    List<ClientModel> filteredClients = _box.values.toList();
    
    // Apply filters
    if (search != null && search.isNotEmpty) {
      final lowercaseSearch = search.toLowerCase();
      filteredClients = filteredClients
          .where((client) => 
              client.name.toLowerCase().contains(lowercaseSearch) ||
              (client.contact?.toLowerCase().contains(lowercaseSearch) ?? false))
          .toList();
    }
    
    if (regionId != null) {
      filteredClients = filteredClients
          .where((client) => client.regionId == regionId)
          .toList();
    }
    
    if (routeId != null) {
      filteredClients = filteredClients
          .where((client) => client.routeId == routeId)
          .toList();
    }
    
    if (status != null) {
      filteredClients = filteredClients
          .where((client) => client.status == status)
          .toList();
    }
    
    // Apply pagination
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    
    if (startIndex >= filteredClients.length) {
      return [];
    }
    
    return filteredClients.sublist(
      startIndex,
      endIndex > filteredClients.length ? filteredClients.length : endIndex,
    );
  }
  
  /// Clear all client data
  static Future<void> clearAll() async {
    await _box.clear();
  }
  
  /// Close the storage
  static Future<void> close() async {
    await _box.close();
  }
  
  /// Get storage statistics
  static Map<String, dynamic> getStorageStats() {
    return {
      'totalClients': _box.length,
      'boxName': _box.name,
      'isOpen': _box.isOpen,
      'isEmpty': _box.isEmpty,
    };
  }
}
