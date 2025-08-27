import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/client.dart';
import '../../domain/usecases/get_clients.dart';
import '../../domain/usecases/search_clients.dart';
import 'clients_state.dart';

class ClientsNotifier extends StateNotifier<ClientsState> {
  final GetClients _getClients;
  final SearchClients _searchClients;

  ClientsNotifier({
    required GetClients getClients,
    required SearchClients searchClients,
  })  : _getClients = getClients,
        _searchClients = searchClients,
        super(const ClientsState());

  Future<void> loadClients({
    int page = 1,
    String? search,
    int? regionId,
    int? routeId,
  }) async {
    if (page == 1) {
      state = state.copyWith(isLoading: true, error: null);
    }

    final result = await _getClients.call(
      GetClientsParams(
        page: page,
        search: search,
        regionId: regionId,
        routeId: routeId,
      ),
    );

    if (result.isSuccess) {
      final clients = result.data!;
      print('🔍 ClientsProvider: Loaded ${clients.length} clients');
      print(
          '🔍 ClientsProvider: Clients: ${clients.map((c) => '${c.id}: ${c.name}').join(', ')}');

      final updatedClients =
          page == 1 ? clients : [...state.clients, ...clients];

      state = state.copyWith(
        clients: updatedClients,
        currentPage: page,
        hasMore: clients.length >= 20,
        isLoading: false,
        searchQuery: search,
      );
    } else {
      state = state.copyWith(
        error: result.error,
        isLoading: false,
      );
    }
  }

  Future<void> searchClients(String query) async {
    if (query.isEmpty) {
      loadClients();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    final result = await _searchClients.call(query);

    if (result.isSuccess) {
      final clients = result.data!;
      state = state.copyWith(
        clients: clients,
        currentPage: 1,
        hasMore: false,
        isLoading: false,
        searchQuery: query,
      );
    } else {
      state = state.copyWith(
        error: result.error,
        isLoading: false,
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearSearch() {
    loadClients();
  }
}
