import 'package:hive_flutter/hive_flutter.dart';
import '../../features/products/data/models/product_model.dart';

class ProductStorage {
  static const String _boxName = 'products';
  static late Box<ProductModel> _box;

  /// Initialize the product storage
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductModelAdapter());
    _box = await Hive.openBox<ProductModel>(_boxName);
  }

  /// Store multiple products (overwrites existing data)
  static Future<void> storeProducts(List<ProductModel> products) async {
    await _box.clear(); // Clear existing data
    for (final product in products) {
      await _box.put(product.id, product);
    }
  }

  /// Store a single product
  static Future<void> storeProduct(ProductModel product) async {
    await _box.put(product.id, product);
  }

  /// Get all products
  static List<ProductModel> getAllProducts() {
    return _box.values.toList();
  }

  /// Get product by ID
  static ProductModel? getProductById(int id) {
    return _box.get(id);
  }

  /// Search products by name or code
  static List<ProductModel> searchProducts(String query) {
    if (query.isEmpty) return getAllProducts();

    final lowercaseQuery = query.toLowerCase();
    return _box.values
        .where((product) =>
            product.productName.toLowerCase().contains(lowercaseQuery) ||
            product.productCode.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  /// Get products by category
  static List<ProductModel> getProductsByCategory(int categoryId) {
    return _box.values
        .where((product) => product.categoryId == categoryId)
        .toList();
  }

  /// Get active products only
  static List<ProductModel> getActiveProducts() {
    return _box.values.where((product) => product.isActive).toList();
  }

  /// Get products with low stock
  static List<ProductModel> getLowStockProducts() {
    return _box.values
        .where((product) =>
            product.currentStock != null &&
            product.reorderLevel != null &&
            product.currentStock! <= product.reorderLevel!)
        .toList();
  }

  /// Update product
  static Future<void> updateProduct(ProductModel product) async {
    await _box.put(product.id, product);
  }

  /// Delete product
  static Future<void> deleteProduct(int id) async {
    await _box.delete(id);
  }

  /// Get product count
  static int getProductCount() {
    return _box.length;
  }

  /// Check if product exists
  static bool productExists(int id) {
    return _box.containsKey(id);
  }

  /// Get products with pagination
  static List<ProductModel> getProductsPaginated({
    required int page,
    required int limit,
    String? search,
    int? categoryId,
    bool? isActive,
  }) {
    List<ProductModel> filteredProducts = _box.values.toList();

    // Apply filters
    if (search != null && search.isNotEmpty) {
      final lowercaseSearch = search.toLowerCase();
      filteredProducts = filteredProducts
          .where((product) =>
              product.productName.toLowerCase().contains(lowercaseSearch) ||
              product.productCode.toLowerCase().contains(lowercaseSearch))
          .toList();
    }

    if (categoryId != null) {
      filteredProducts = filteredProducts
          .where((product) => product.categoryId == categoryId)
          .toList();
    }

    if (isActive != null) {
      filteredProducts = filteredProducts
          .where((product) => product.isActive == isActive)
          .toList();
    }

    // Apply pagination
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= filteredProducts.length) {
      return [];
    }

    return filteredProducts.sublist(
      startIndex,
      endIndex > filteredProducts.length ? filteredProducts.length : endIndex,
    );
  }

  /// Clear all product data
  static Future<void> clearAll() async {
    await _box.clear();
  }

  /// Close the storage
  static Future<void> close() async {
    await _box.close();
  }

  /// Get storage statistics
  static Map<String, dynamic> getStorageStats() {
    return {
      'totalProducts': _box.length,
      'boxName': _box.name,
      'isOpen': _box.isOpen,
      'isEmpty': _box.isEmpty,
    };
  }
}
