import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/providers/product_provider.dart';

class ProductListController extends GetxController {
  var isLoading = true.obs;
  var productList = <Product>[].obs;

  final ProductRepository repository = ProductRepository(ProductProvider());

  @override
  void onInit() {
    fetchProducts();
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
}
