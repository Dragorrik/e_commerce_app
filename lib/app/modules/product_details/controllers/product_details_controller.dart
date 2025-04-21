import 'package:get/get.dart';
import '../../../data/models/product_model.dart';

class ProductDetailsController extends GetxController {
  late Product product;

  @override
  void onInit() {
    product = Get.arguments as Product;
    super.onInit();
  }
}
