import '../models/client_model.dart';
import '../../../../core/storage/client_storage.dart';

abstract class ClientsLocalDataSource {
  Future<List<ClientModel>> getClients({
    int page = 1,
    int limit = 20,
    String? search,
    int? regionId,
    int? routeId,
  });
  
  Future<ClientModel?> getClient(int id);
  
  Future<List<ClientModel>> searchClients(String query);
  
  Future<List<ClientModel>> getClientsByRoute(int routeId);
  
  Future<List<ClientModel>> getClientsByRegion(int regionId);
  
  Future<void> storeClients(List<ClientModel> clients);
  
  Future<void> storeClient(ClientModel client);
  
  Future<void> updateClient(ClientModel client);
  
  Future<void> deleteClient(int id);
  
  Future<int> getClientCount();
  
  Future<bool> hasData();
}

class ClientsLocalDataSourceImpl implements ClientsLocalDataSource {
  @override
  Future<List<ClientModel>> getClients({
    int page = 1,
    int limit = 20,
    String? search,
    int? regionId,
    int? routeId,
  }) async {
    try {
      return ClientStorage.getClientsPaginated(
        page: page,
        limit: limit,
        search: search,
        regionId: regionId,
        routeId: routeId,
      );
    } catch (e) {
      throw Exception('Failed to get clients from local storage: $e');
    }
  }
  
  @override
  Future<ClientModel?> getClient(int id) async {
    try {
      return ClientStorage.getClientById(id);
    } catch (e) {
      throw Exception('Failed to get client from local storage: $e');
    }
  }
  
  @override
  Future<List<ClientModel>> searchClients(String query) async {
    try {
      return ClientStorage.searchClients(query);
    } catch (e) {
      throw Exception('Failed to search clients in local storage: $e');
    }
  }
  
  @override
  Future<List<ClientModel>> getClientsByRoute(int routeId) async {
    try {
      return ClientStorage.getClientsByRoute(routeId);
    } catch (e) {
      throw Exception('Failed to get clients by route from local storage: $e');
    }
  }
  
  @override
  Future<List<ClientModel>> getClientsByRegion(int regionId) async {
    try {
      return ClientStorage.getClientsByRegion(regionId);
    } catch (e) {
      throw Exception('Failed to get clients by region from local storage: $e');
    }
  }
  
  @override
  Future<void> storeClients(List<ClientModel> clients) async {
    try {
      await ClientStorage.storeClients(clients);
    } catch (e) {
      throw Exception('Failed to store clients in local storage: $e');
    }
  }
  
  @override
  Future<void> storeClient(ClientModel client) async {
    try {
      await ClientStorage.storeClient(client);
    } catch (e) {
      throw Exception('Failed to store client in local storage: $e');
    }
  }
  
  @override
  Future<void> updateClient(ClientModel client) async {
    try {
      await ClientStorage.updateClient(client);
    } catch (e) {
      throw Exception('Failed to update client in local storage: $e');
    }
  }
  
  @override
  Future<void> deleteClient(int id) async {
    try {
      await ClientStorage.deleteClient(id);
    } catch (e) {
      throw Exception('Failed to delete client from local storage: $e');
    }
  }
  
  @override
  Future<int> getClientCount() async {
    try {
      return ClientStorage.getClientCount();
    } catch (e) {
      throw Exception('Failed to get client count from local storage: $e');
    }
  }
  
  @override
  Future<bool> hasData() async {
    try {
      return ClientStorage.getClientCount() > 0;
    } catch (e) {
      return false;
    }
  }
}
