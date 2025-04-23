import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search + Filters
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                SizedBox(height: 40),
                Text('Products',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    )),
                SizedBox(height: 20),
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products by product name...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(14),
                    ),
                    onChanged: controller.search,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return SizedBox(
                    height: 45,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: controller.categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = controller.categories[index];
                        final isSelected =
                            controller.selectedCategory.value == cat;

                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          showCheckmark: false,
                          onSelected: (_) => controller.filterByCategory(cat),
                          selectedColor: Colors.blue.shade600,
                          backgroundColor: Colors.grey.shade200,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        );
                      },
                    ),
                  );
                }),

                SizedBox(height: 16),

                // Sorting Dropdown
                Obx(() {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(0XFFFEF7FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedSort.value,
                          icon:
                              const Icon(Icons.sort, color: Colors.blueAccent),
                          dropdownColor: Color(0XFFFEF7FF),
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, color: Colors.black),
                          items: [
                            'Price: Low to High',
                            'Price: High to Low',
                            'Rating: Low to High',
                            'Rating: High to Low',
                          ].map((label) {
                            return DropdownMenuItem<String>(
                              value: label,
                              child: Row(
                                children: [
                                  Icon(
                                    label.contains('Price')
                                        ? Icons.attach_money
                                        : Icons.star_rate,
                                    color: label.contains('Price')
                                        ? Colors.lightGreen
                                        : Colors.orangeAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(label),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.sortProducts(value);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Product Grid/List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return RefreshIndicator(
                onRefresh: () async {
                  return controller.fetchProducts();
                },
                child: ListView.builder(
                  itemCount: controller.productList.length,
                  itemBuilder: (context, index) {
                    final product = controller.productList[index];
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed('/product-details', arguments: product);
                        },
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Hero(
                                  tag: product.id,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      product.thumbnail,
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(product.title,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          )),
                                      const SizedBox(height: 4),
                                      Text(
                                        product.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade700),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('\$${product.price}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Row(
                                            children: [
                                              const Icon(Icons.star,
                                                  color: Colors.amber,
                                                  size: 16),
                                              const SizedBox(width: 4),
                                              Text('${product.rating}'),
                                              const SizedBox(width: 8),
                                              Obx(() {
                                                final isFav = controller
                                                    .isFavorite(product.id);
                                                return IconButton(
                                                  icon: Icon(
                                                    isFav
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: isFav
                                                        ? Colors.red
                                                        : Colors.grey,
                                                    size: 20,
                                                  ),
                                                  onPressed: () =>
                                                      controller.toggleFavorite(
                                                          product.id),
                                                  padding: EdgeInsets.zero,
                                                  constraints: BoxConstraints(),
                                                );
                                              }),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
