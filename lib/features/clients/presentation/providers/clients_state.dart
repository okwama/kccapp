import '../../domain/entities/client.dart';

class ClientsState {
  final List<Client> clients;
  final int currentPage;
  final bool hasMore;
  final bool isLoading;
  final String? error;
  final String? searchQuery;

  const ClientsState({
    this.clients = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoading = false,
    this.error,
    this.searchQuery,
  });

  ClientsState copyWith({
    List<Client>? clients,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return ClientsState(
      clients: clients ?? this.clients,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
