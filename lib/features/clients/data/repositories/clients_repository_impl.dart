import '../../domain/repositories/clients_repository.dart';
import '../../domain/entities/client.dart';
import '../datasources/clients_remote_data_source.dart';
import '../datasources/clients_local_data_source.dart';

class ClientsRepositoryImpl implements ClientsRepository {
  final ClientsRemoteDataSource _remoteDataSource;
  final ClientsLocalDataSource _localDataSource;

  ClientsRepositoryImpl({
    required ClientsRemoteDataSource remoteDataSource,
    required ClientsLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Result<List<Client>>> getClients({
    int page = 1,
    int limit = 20,
    String? search,
    int? regionId,
    int? routeId,
  }) async {
    try {
      // First, try to get data from local storage
      final localClients = await _localDataSource.getClients(
        page: page,
        limit: limit,
        search: search,
        regionId: regionId,
        routeId: routeId,
      );

      // If we have local data, return it immediately
      if (localClients.isNotEmpty) {
        final clients = localClients.map((model) => model.toEntity()).toList();
        return Success(clients);
      }

      // If no local data, fetch from remote and store locally
      final remoteClients = await _remoteDataSource.getClients(
        page: page,
        limit: limit,
        search: search,
        regionId: regionId,
        routeId: routeId,
      );

      // Store in local storage for future offline access
      await _localDataSource.storeClients(remoteClients);

      final clients = remoteClients.map((model) => model.toEntity()).toList();
      return Success(clients);
    } catch (e) {
      // If remote fails, try to get any available local data
      try {
        final fallbackClients = await _localDataSource.getClients(
          page: page,
          limit: limit,
          search: search,
          regionId: regionId,
          routeId: routeId,
        );
        
        if (fallbackClients.isNotEmpty) {
          final clients = fallbackClients.map((model) => model.toEntity()).toList();
          return Success(clients);
        }
      } catch (localError) {
        // Local storage also failed
      }
      
      return Failure('Failed to fetch clients: ${e.toString()}');
    }
  }

  @override
  Future<Result<Client>> getClient(int id) async {
    try {
      // First, try to get from local storage
      final localClient = await _localDataSource.getClient(id);
      if (localClient != null) {
        return Success(localClient.toEntity());
      }

      // If not in local storage, fetch from remote
      final remoteClient = await _remoteDataSource.getClient(id);
      
      // Store in local storage for future access
      await _localDataSource.storeClient(remoteClient);
      
      return Success(remoteClient.toEntity());
    } catch (e) {
      return Failure('Failed to fetch client: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<Client>>> searchClients(String query) async {
    try {
      // First, try local search
      final localResults = await _localDataSource.searchClients(query);
      if (localResults.isNotEmpty) {
        final clients = localResults.map((model) => model.toEntity()).toList();
        return Success(clients);
      }

      // If no local results, try remote search
      final remoteResults = await _remoteDataSource.searchClients(query);
      
      // Store results locally
      await _localDataSource.storeClients(remoteResults);
      
      final clients = remoteResults.map((model) => model.toEntity()).toList();
      return Success(clients);
    } catch (e) {
      return Failure('Failed to search clients: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<Client>>> getClientsByRoute(int routeId) async {
    try {
      // First, try local storage
      final localClients = await _localDataSource.getClientsByRoute(routeId);
      if (localClients.isNotEmpty) {
        final clients = localClients.map((model) => model.toEntity()).toList();
        return Success(clients);
      }

      // If no local data, fetch from remote
      final remoteClients = await _remoteDataSource.getClientsByRoute(routeId);
      
      // Store locally
      await _localDataSource.storeClients(remoteClients);
      
      final clients = remoteClients.map((model) => model.toEntity()).toList();
      return Success(clients);
    } catch (e) {
      return Failure('Failed to fetch clients by route: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<Client>>> getClientsByRegion(int regionId) async {
    try {
      // First, try local storage
      final localClients = await _localDataSource.getClientsByRegion(regionId);
      if (localClients.isNotEmpty) {
        final clients = localClients.map((model) => model.toEntity()).toList();
        return Success(clients);
      }

      // If no local data, fetch from remote
      final remoteClients = await _remoteDataSource.getClientsByRegion(regionId);
      
      // Store locally
      await _localDataSource.storeClients(remoteClients);
      
      final clients = remoteClients.map((model) => model.toEntity()).toList();
      return Success(clients);
    } catch (e) {
      return Failure('Failed to fetch clients by region: ${e.toString()}');
    }
  }

  /// Refresh local data from remote source
  Future<Result<void>> refreshLocalData() async {
    try {
      // Fetch fresh data from remote
      final remoteClients = await _remoteDataSource.getClients(
        page: 1,
        limit: 1000, // Get all clients for local storage
      );
      
      // Store in local storage
      await _localDataSource.storeClients(remoteClients);
      
      return Success(null);
    } catch (e) {
      return Failure('Failed to refresh local data: ${e.toString()}');
    }
  }

  /// Check if local data exists
  Future<bool> hasLocalData() async {
    return await _localDataSource.hasData();
  }

  /// Get local client count
  Future<int> getLocalClientCount() async {
    return await _localDataSource.getClientCount();
  }
}
