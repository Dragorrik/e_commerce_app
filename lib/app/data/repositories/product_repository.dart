import '../models/product_model.dart';
import '../providers/product_provider.dart';

class ProductRepository {
  final ProductProvider _provider;

  ProductRepository(this._provider);

  Future<List<Product>> getAllProducts() {
    return _provider.fetchProducts();
  }

  Future<List<Product>> searchProducts(String query) {
    return _provider.searchProducts(query);
  }

  Future<List<String>> getCategories() {
    return _provider.fetchCategories();
  }

  Future<List<Product>> getProductsByCategory(String category) {
    return _provider.fetchProductsByCategory(category);
  }
}
