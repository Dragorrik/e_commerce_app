import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/providers/product_provider.dart';

class ProductListController extends GetxController {
  var isLoading = true.obs;
  var productList = <Product>[].obs;
  var categories = <String>[].obs;
  var selectedCategory = ''.obs;

  final ProductRepository repository = ProductRepository(ProductProvider());

  @override
  void onInit() {
    fetchProducts();
    fetchCategories();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var products = await repository.getAllProducts();
      productList.assignAll(products);
    } finally {
      isLoading(false);
    }
  }

  void search(String query) async {
    if (query.isEmpty) {
      fetchProducts();
      return;
    }

    try {
      isLoading(true);
      var results = await repository.searchProducts(query);
      productList.assignAll(results);
    } finally {
      isLoading(false);
    }
  }

  void fetchCategories() async {
    try {
      var result = await repository.getCategories();
      print("CATEGORIES: $result");
      categories.assignAll(result);
    } catch (e) {
      print("Error loading categories: $e");
    }
  }

  void filterByCategory(String category) async {
    try {
      isLoading(true);
      selectedCategory.value = category;
      var filtered = await repository.getProductsByCategory(category);
      productList.assignAll(filtered);
    } finally {
      isLoading(false);
    }
  }
}
