import '../models/product_model.dart';
import '../../../../core/storage/product_storage.dart';

abstract class ProductsLocalDataSource {
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    int? categoryId,
    bool? isActive,
  });
  
  Future<ProductModel?> getProduct(int id);
  
  Future<List<ProductModel>> searchProducts(String query);
  
  Future<List<ProductModel>> getProductsByCategory(int categoryId);
  
  Future<List<ProductModel>> getActiveProducts();
  
  Future<List<ProductModel>> getLowStockProducts();
  
  Future<void> storeProducts(List<ProductModel> products);
  
  Future<void> storeProduct(ProductModel product);
  
  Future<void> updateProduct(ProductModel product);
  
  Future<void> deleteProduct(int id);
  
  Future<int> getProductCount();
  
  Future<bool> hasData();
}

class ProductsLocalDataSourceImpl implements ProductsLocalDataSource {
  @override
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    int? categoryId,
    bool? isActive,
  }) async {
    try {
      return ProductStorage.getProductsPaginated(
        page: page,
        limit: limit,
        search: search,
        categoryId: categoryId,
        isActive: isActive,
      );
    } catch (e) {
      throw Exception('Failed to get products from local storage: $e');
    }
  }
  
  @override
  Future<ProductModel?> getProduct(int id) async {
    try {
      return ProductStorage.getProductById(id);
    } catch (e) {
      throw Exception('Failed to get product from local storage: $e');
    }
  }
  
  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      return ProductStorage.searchProducts(query);
    } catch (e) {
      throw Exception('Failed to search products in local storage: $e');
    }
  }
  
  @override
  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    try {
      return ProductStorage.getProductsByCategory(categoryId);
    } catch (e) {
      throw Exception('Failed to get products by category from local storage: $e');
    }
  }
  
  @override
  Future<List<ProductModel>> getActiveProducts() async {
    try {
      return ProductStorage.getActiveProducts();
    } catch (e) {
      throw Exception('Failed to get active products from local storage: $e');
    }
  }
  
  @override
  Future<List<ProductModel>> getLowStockProducts() async {
    try {
      return ProductStorage.getLowStockProducts();
    } catch (e) {
      throw Exception('Failed to get low stock products from local storage: $e');
    }
  }
  
  @override
  Future<void> storeProducts(List<ProductModel> products) async {
    try {
      await ProductStorage.storeProducts(products);
    } catch (e) {
      throw Exception('Failed to store products in local storage: $e');
    }
  }
  
  @override
  Future<void> storeProduct(ProductModel product) async {
    try {
      await ProductStorage.storeProduct(product);
    } catch (e) {
      throw Exception('Failed to store product in local storage: $e');
    }
  }
  
  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
      await ProductStorage.updateProduct(product);
    } catch (e) {
      throw Exception('Failed to update product in local storage: $e');
    }
  }
  
  @override
  Future<void> deleteProduct(int id) async {
    try {
      await ProductStorage.deleteProduct(id);
    } catch (e) {
      throw Exception('Failed to delete product from local storage: $e');
    }
  }
  
  @override
  Future<int> getProductCount() async {
    try {
      return ProductStorage.getProductCount();
    } catch (e) {
      throw Exception('Failed to get product count from local storage: $e');
    }
  }
  
  @override
  Future<bool> hasData() async {
    try {
      return ProductStorage.getProductCount() > 0;
    } catch (e) {
      return false;
    }
  }
}
