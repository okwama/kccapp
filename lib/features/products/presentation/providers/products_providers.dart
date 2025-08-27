import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../../data/services/products_service.dart';
import '../../data/models/product_model.dart';

// Products Service Provider
final productsServiceProvider = Provider<ProductsService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProductsService(apiClient.dio);
});

// Products State
class ProductsState {
  final List<ProductModel> products;
  final bool isLoading;
  final String? error;

  ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.error,
  });

  ProductsState copyWith({
    List<ProductModel>? products,
    bool? isLoading,
    String? error,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Products Notifier
class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsService _productsService;

  ProductsNotifier(this._productsService) : super(ProductsState());

  Future<void> fetchAllProducts() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final products = await _productsService.getAllProducts();
      state = state.copyWith(products: products, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch products: $e',
      );
    }
  }

  Future<void> fetchProductsByCountry(int countryId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final products = await _productsService.getProductsByCountry(countryId);
      state = state.copyWith(products: products, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch country products: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void resetState() {
    state = ProductsState();
  }
}

// Products Notifier Provider
final productsNotifierProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsService = ref.watch(productsServiceProvider);
  return ProductsNotifier(productsService);
});
