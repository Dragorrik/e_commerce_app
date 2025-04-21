import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "E-commerce App",
      initialRoute: Routes.PRODUCT_LIST,
      getPages: AppPages.routes,
    ),
  );
}
