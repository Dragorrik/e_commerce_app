import 'package:e_commerce_app/app/modules/login/controllers/login_controller.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/providers/product_provider.dart';

class ProductListController extends GetxController {
  var isLoading = true.obs;
  var productList = <Product>[].obs;
  var categories = <String>[].obs;
  var selectedCategory = ''.obs;
  var selectedSort = 'Price: Low to High'.obs;
  final RxSet<int> favoriteIds = <int>{}.obs;
  RxList<Product> allProducts = <Product>[].obs;
  LoginController loginController = Get.put(LoginController());

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
      allProducts.assignAll(products);
      productList.assignAll(products);
    } catch (e) {
      print("Error loading products: $e");
      // Handle error, maybe show a message to the user
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
      categories.value = ['All', ...result];
    } catch (e) {
      print("Error loading categories: $e");
    }
  }

  void filterByCategory(String category) async {
    try {
      isLoading(true);
      selectedCategory.value = category;

      if (category == 'All') {
        var allProducts = await repository.getAllProducts();
        productList.assignAll(allProducts);
      } else {
        var filtered = await repository.getProductsByCategory(category);
        productList.assignAll(filtered);
      }
    } finally {
      isLoading(false);
    }
  }

  void sortProducts(String sortOption) {
    selectedSort.value = sortOption;

    List<Product> sorted = [
      ...allProducts
    ]; // Keep a full list cached in allProducts

    switch (sortOption) {
      case 'Price: Low to High':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating: Low to High':
        sorted.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case 'Rating: High to Low':
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Favorites Only':
        sorted = sorted
            .where((product) => favoriteIds.contains(product.id))
            .toList();
        break;
    }

    productList.assignAll(sorted);
  }

  void toggleFavorite(int productId) {
    if (favoriteIds.contains(productId)) {
      favoriteIds.remove(productId);
    } else {
      favoriteIds.add(productId);
    }
  }

  bool isFavorite(int productId) => favoriteIds.contains(productId);

  void logout() {
    loginController.logout();
  }
}
