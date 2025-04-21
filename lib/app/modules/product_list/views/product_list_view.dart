import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  const ProductListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.productList.length,
          itemBuilder: (context, index) {
            final product = controller.productList[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: Image.network(product.thumbnail, width: 60),
                title: Text(product.title),
                subtitle: Text('\$${product.price} | ${product.rating}⭐'),
                onTap: () {
                  // Navigate to detail page later
                },
              ),
            );
          },
        );
      }),
    );
  }
}
