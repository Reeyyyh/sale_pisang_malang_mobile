
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/models/items_model.dart';
import 'package:sale_pisang_malang/app/modules/client/page/2_MyOrder/controllers/cart_page_controller.dart';

class CardDetailController extends GetxController {
  final CartPageController _cartPageController = Get.find<CartPageController>(); // Mendapatkan instance CartPageController

  // Fungsi untuk menambahkan item ke keranjang
  Future<void> addItemToCart(ItemModel item) async {
    try {
      await _cartPageController.addToCart(item); // Panggil addToCart dari CartPageController
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add item to cart: $e",
        backgroundColor: Colors.red[400]!.withOpacity(0.6), // Warna merah untuk error
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        borderRadius: 15,
      );
    }
  }
}
