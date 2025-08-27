import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/clients_providers.dart';
import '../providers/clients_state.dart';
import '../widgets/client_card.dart';
import '../widgets/client_search_bar.dart';

class ClientsListPage extends ConsumerStatefulWidget {
  const ClientsListPage({super.key});

  @override
  ConsumerState<ClientsListPage> createState() => _ClientsListPageState();
}

class _ClientsListPageState extends ConsumerState<ClientsListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clientsNotifierProvider.notifier).loadClients();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = ref.read(clientsNotifierProvider);
      if (state.hasMore && !state.isLoading) {
        ref.read(clientsNotifierProvider.notifier).loadClients(
              page: state.currentPage + 1,
              search: state.searchQuery,
            );
      }
    }
  }

  void _onSearch(String query) {
    ref.read(clientsNotifierProvider.notifier).loadClients(
          page: 1,
          search: query.isEmpty ? null : query,
        );
  }

  void _onRefresh() {
    ref.read(clientsNotifierProvider.notifier).loadClients(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    final clientsState = ref.watch(clientsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/clients/add'),
            tooltip: 'Add Client',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClientSearchBar(
              controller: _searchController,
              onSearch: _onSearch,
            ),
          ),

          // Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _onRefresh(),
              child: _buildContent(clientsState),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ClientsState state) {
    if (state.isLoading && state.clients.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading clients...'),
          ],
        ),
      );
    }

    if (state.error != null && state.clients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading clients',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.error!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _onRefresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.clients.isEmpty && !state.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No clients found',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.searchQuery != null && state.searchQuery!.isNotEmpty
                  ? 'Try adjusting your search terms'
                  : 'Add your first client to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (state.searchQuery == null || state.searchQuery!.isEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.push('/clients/add'),
                icon: const Icon(Icons.add),
                label: const Text('Add Client'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: state.clients.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.clients.length) {
          return _buildLoadingIndicator();
        }

        final client = state.clients[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ClientCard(
            client: client,
            onTap: () => context.push('/clients/${client.id}'),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
