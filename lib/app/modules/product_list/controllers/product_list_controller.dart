import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/app/modules/login/controllers/login_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final ProductRepository repository = ProductRepository(ProductProvider());

  @override
  void onInit() {
    fetchProducts();
    fetchCategories();
    loadFavorites();
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

    List<Product> sorted = [...allProducts];

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
            .where((product) => isFavorite(product.id)) // Firestore check
            .toList();
        break;
    }

    productList.assignAll(sorted);
  }

  // void toggleFavorite(int productId) {
  //   if (favoriteIds.contains(productId)) {
  //     favoriteIds.remove(productId);
  //   } else {
  //     favoriteIds.add(productId);
  //   }
  // }

  // bool isFavorite(int productId) => favoriteIds.contains(productId);

  Future<void> loadFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    favoriteIds
        .assignAll(snapshot.docs.map((doc) => int.parse(doc.id)).toSet());
  }

  Future<void> toggleFavorite(int productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final favRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(productId.toString());

    if (favoriteIds.contains(productId)) {
      await favRef.delete();
      favoriteIds.remove(productId);
    } else {
      await favRef.set({'createdAt': Timestamp.now()});
      favoriteIds.add(productId);
    }
  }

  bool isFavorite(int productId) => favoriteIds.contains(productId);

  void logout() {
    loginController.logout();
  }
}
