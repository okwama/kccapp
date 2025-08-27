import '../entities/client.dart';

// Simple Result pattern for clients
abstract class Result<T> {
  const Result();
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  T? get data => isSuccess ? (this as Success<T>).data : null;
  String? get error => isFailure ? (this as Failure<T>).error : null;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String error;
  const Failure(this.error);
}

abstract class ClientsRepository {
  Future<Result<List<Client>>> getClients({
    int page = 1,
    int limit = 20,
    String? search,
    int? regionId,
    int? routeId,
  });

  Future<Result<Client>> getClient(int id);
  Future<Result<List<Client>>> searchClients(String query);
  Future<Result<List<Client>>> getClientsByRoute(int routeId);
  Future<Result<List<Client>>> getClientsByRegion(int regionId);
}
