import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';

class ProductProvider {
  final String baseUrl = 'https://dummyjson.com/products';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl?limit=100'));

    if (response.statusCode == 200) {
      final List productsJson = json.decode(response.body)['products'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await http
        .get(Uri.parse('https://dummyjson.com/products/search?q=$query'));

    if (response.statusCode == 200) {
      final List productsJson = json.decode(response.body)['products'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search products');
    }
  }
}
