import '../repositories/clients_repository.dart';
import '../entities/client.dart';

class SearchClients {
  final ClientsRepository _repository;

  SearchClients(this._repository);

  Future<Result<List<Client>>> call(String query) {
    return _repository.searchClients(query);
  }
}
