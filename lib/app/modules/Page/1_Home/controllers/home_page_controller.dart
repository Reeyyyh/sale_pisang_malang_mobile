import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sale_pisang_malang/app/models/items_model.dart';
import 'package:sale_pisang_malang/app/modules/Page/3_Favorite/controllers/favorite_page_controller.dart';

import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';

class HomeController extends GetxController {
  var items = <ItemModel>[].obs;
  final AuthService _authService = Get.find<AuthService>();
  final FavoriteController _favoriteController = Get.put(FavoriteController());

  var isLoggedIn = false.obs;
  var isLoading = true.obs; // Status loading
  var hasError = false.obs; // Status error jika tidak ada data setelah 2 detik

  @override
  void onInit() {
    super.onInit();
    fetchItems();
    checkUserStatus();
    startLoadingTimeout();
  }

  void fetchItems() {
    FirebaseFirestore.instance
        .collection('items')
        .snapshots()
        .listen((snapshot) {
      items.value = snapshot.docs.map((doc) => ItemModel.fromDocument(doc)).toList();
      isLoading.value = false; // Set loading selesai saat data sudah ada
      hasError.value = items.isEmpty; // Jika tetap kosong, set error
    });
  }

  void startLoadingTimeout() {
    Future.delayed(const Duration(seconds: 2), () {
      if (items.isEmpty) {
        isLoading.value = false;
        hasError.value = true;
      }
    });
  }

  void checkUserStatus() {
    if (_authService.isUserLoggedIn()) {
      isLoggedIn.value = true;
    } else {
      _authService.initializeGuestUser();
      isLoggedIn.value = false;
    }
  }

  bool get isUserGuest => _authService.currentUserData?['role'] == 'guest';

  void checkUserAccess(String featureName) {
    if (isUserGuest) {
      Get.snackbar(
        'Login Required',
        'Please login to add item in $featureName',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } else {
      // Akses diizinkan
    }
  }

  Future<void> addToFavorites(ItemModel item) async {
    if (isUserGuest) {
      checkUserAccess('Favorites');
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userID = user.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('favorites')
          .doc(item.id)
          .set({
        'itemName': item.name,
        'itemPrice': item.harga,
      });
      _favoriteController.fetchFavorites(); // Memperbarui tampilan favorit
      Get.snackbar('Success', 'Item ${item.name} added to favorites.');
    }
  }
}
