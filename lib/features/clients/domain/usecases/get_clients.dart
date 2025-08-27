import '../repositories/clients_repository.dart';
import '../entities/client.dart';

class GetClientsParams {
  final int page;
  final int limit;
  final String? search;
  final int? regionId;
  final int? routeId;

  const GetClientsParams({
    this.page = 1,
    this.limit = 20,
    this.search,
    this.regionId,
    this.routeId,
  });
}

class GetClients {
  final ClientsRepository _repository;

  GetClients(this._repository);

  Future<Result<List<Client>>> call(GetClientsParams params) {
    return _repository.getClients(
      page: params.page,
      limit: params.limit,
      search: params.search,
      regionId: params.regionId,
      routeId: params.routeId,
    );
  }
}
