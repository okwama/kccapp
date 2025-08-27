import '../../domain/repositories/clients_repository.dart';
import '../../domain/entities/client.dart';
import '../datasources/clients_remote_data_source.dart';

class ClientsRepositoryImpl implements ClientsRepository {
  final ClientsRemoteDataSource _remoteDataSource;

  ClientsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Client>>> getClients({
    int page = 1,
    int limit = 20,
    String? search,
    int? regionId,
    int? routeId,
  }) async {
    try {
      final clientModels = await _remoteDataSource.getClients(
        page: page,
        limit: limit,
        search: search,
        regionId: regionId,
        routeId: routeId,
      );

      final clients = clientModels.map((model) => model.toEntity()).toList();
      return Success(clients);
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }

  @override
  Future<Result<Client>> getClient(int id) async {
    try {
      final clientModel = await _remoteDataSource.getClient(id);
      final client = clientModel.toEntity();
      return Success(client);
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<Client>>> searchClients(String query) async {
    try {
      final clientModels = await _remoteDataSource.searchClients(query);
      final clients = clientModels.map((model) => model.toEntity()).toList();
      return Success(clients);
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<Client>>> getClientsByRoute(int routeId) async {
    try {
      final clientModels = await _remoteDataSource.getClientsByRoute(routeId);
      final clients = clientModels.map((model) => model.toEntity()).toList();
      return Success(clients);
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<Client>>> getClientsByRegion(int regionId) async {
    try {
      final clientModels = await _remoteDataSource.getClientsByRegion(regionId);
      final clients = clientModels.map((model) => model.toEntity()).toList();
      return Success(clients);
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }
}
