import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ProductsService {
  final Dio _dio;

  ProductsService(this._dio);

  Future<List<ProductModel>> getAllProducts() async {
    try {
      print('📦 Fetching all products...');
      final response = await _dio.get('/products');
      print('✅ Products fetched successfully: ${response.data.length} products');
      
      final List<ProductModel> products = (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
      
      return products;
    } catch (e) {
      print('❌ Error fetching products: $e');
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsByCountry(int countryId) async {
    try {
      print('🌍 Fetching products for country $countryId...');
      final response = await _dio.get('/products/country/$countryId');
      print('✅ Country products fetched successfully: ${response.data.length} products');
      
      final List<ProductModel> products = (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
      
      return products;
    } catch (e) {
      print('❌ Error fetching country products: $e');
      rethrow;
    }
  }

  Future<ProductModel?> getProductById(int productId) async {
    try {
      print('🔍 Fetching product by ID: $productId...');
      final response = await _dio.get('/products/$productId');
      print('✅ Product fetched successfully');
      
      return ProductModel.fromJson(response.data);
    } catch (e) {
      print('❌ Error fetching product by ID: $e');
      return null;
    }
  }
}
