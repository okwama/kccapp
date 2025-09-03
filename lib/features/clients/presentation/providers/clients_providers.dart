import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/providers/providers.dart';
import '../../data/datasources/clients_remote_data_source.dart';
import '../../data/datasources/clients_local_data_source.dart';
import '../../data/repositories/clients_repository_impl.dart';
import '../../domain/usecases/get_clients.dart';
import '../../domain/usecases/search_clients.dart';
import 'clients_provider.dart';
import 'clients_state.dart';

// Data Sources
final clientsRemoteDataSourceProvider =
    Provider<ClientsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ClientsRemoteDataSourceImpl(apiClient.dio);
});

final clientsLocalDataSourceProvider = Provider<ClientsLocalDataSource>((ref) {
  return ClientsLocalDataSourceImpl();
});

// Repository
final clientsRepositoryProvider = Provider<ClientsRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(clientsRemoteDataSourceProvider);
  final localDataSource = ref.watch(clientsLocalDataSourceProvider);
  return ClientsRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// Use Cases
final getClientsProvider = Provider<GetClients>((ref) {
  final repository = ref.watch(clientsRepositoryProvider);
  return GetClients(repository);
});

final searchClientsProvider = Provider<SearchClients>((ref) {
  final repository = ref.watch(clientsRepositoryProvider);
  return SearchClients(repository);
});

// State Notifier
final clientsNotifierProvider =
    StateNotifierProvider<ClientsNotifier, ClientsState>((ref) {
  final getClients = ref.watch(getClientsProvider);
  final searchClients = ref.watch(searchClientsProvider);
  return ClientsNotifier(
    getClients: getClients,
    searchClients: searchClients,
  );
});
