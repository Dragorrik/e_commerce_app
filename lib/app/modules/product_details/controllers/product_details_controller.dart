import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/product_model.dart';

class ProductDetailsController extends GetxController {
  late Product product;

  final quantity = 1.obs;

  @override
  void onInit() {
    product = Get.arguments as Product;
    super.onInit();
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void buyNow() {
    TextEditingController addressController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: "Billing Info",
      titleStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      content: Column(
        children: [
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              labelText: "Phone Number",
              labelStyle: GoogleFonts.poppins(),
              hintText: "e.g. 017xxxxxxxx",
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              prefixIcon: Icon(Icons.phone, color: Colors.blueAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: addressController,
            maxLines: 3,
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              labelText: "Delivery Address",
              labelStyle: GoogleFonts.poppins(),
              hintText: "e.g. 123 Main Street, Dhaka",
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              prefixIcon: Icon(Icons.location_on, color: Colors.redAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: () async {
          final address = addressController.text.trim();
          final phone = phoneController.text.trim();

          if (address.isEmpty || phone.isEmpty) {
            Get.snackbar("Missing Info", "Please fill in all fields",
                backgroundColor: Colors.redAccent, colorText: Colors.white);
            return;
          }

          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId == null) return;

          await FirebaseFirestore.instance.collection('orders').add({
            'userId': userId,
            'productId': product.id,
            'productTitle': product.title,
            'quantity': quantity.value,
            'price': product.price,
            'total': product.price * quantity.value,
            'address': address,
            'phone': phone,
            'timestamp': FieldValue.serverTimestamp(),
          });

          Get.back(); // Close dialog
          Get.snackbar(
            'Order Placed',
            'Your order has been successfully placed!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        child: Text(
          "Confirm",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
