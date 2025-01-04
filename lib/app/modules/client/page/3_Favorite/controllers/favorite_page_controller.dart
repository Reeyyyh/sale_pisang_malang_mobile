import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/models/items_model.dart';
import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';

class FavoriteController extends GetxController {
  var isGuest = false.obs;
  final AuthService _authService = Get.find<AuthService>();
  // final HomeController _homeController = Get.find<HomeController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<FavoriteItem> favorites =
      <FavoriteItem>[].obs; // List untuk menyimpan item favorit

  var isFavorites = <String>{}.obs; // Set untuk menyimpan ID item favorit

  RxBool isItemInFavorites(String itemId) {
    return isFavorites.contains(itemId).obs;
  }

  bool get isUserGuest => _authService.currentUserData?['role'] == 'guest';

  @override
  void onInit() {
    super.onInit();
    checkUserStatus();
    if (!isGuest.value) {
      fetchFavorites();
    }
  }

  void checkUserStatus() {
    if (_authService.isUserLoggedIn()) {
      isGuest.value = false;
    } else {
      _authService.initializeGuestUser();
      isGuest.value = true;
    }
  }

  void checkUserAccess(String featureName) {
    if (isUserGuest) {
      Get.snackbar(
        'Login Required',
        'Please login to add item in $featureName',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
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
      // Tutup semua Snackbar yang sedang aktif
      Get.closeAllSnackbars();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('favorites')
          .doc(item.id)
          .set({
        'id': item.id,
        'itemName': item.name,
        'itemPrice': item.harga,
      });

      isFavorites.add(item.id); // Perbarui lokal
      fetchFavorites(); // Pastikan UI diperbarui dengan data terbaru
      Get.snackbar(
        'Success',
        'Item ${item.name} added to favorites',
        duration: const Duration(seconds: 1, milliseconds: 500),
        animationDuration: Duration.zero,
        backgroundColor: Colors.green[400]!
            .withOpacity(0.6),
        colorText: Colors.black,
        snackPosition: SnackPosition.TOP,
        borderRadius: 15,
      );
    }
  }

  // Fungsi untuk menghapus item dari daftar favorit
  Future<void> removeFromFavorites(String itemId, String itemName) async {
    if (isUserGuest) {
      checkUserAccess('Favorites');
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Tutup semua Snackbar yang sedang aktif
      Get.closeAllSnackbars();
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(itemId)
          .delete();

      isFavorites.remove(itemId); // Perbarui lokal
      fetchFavorites(); // Pastikan UI diperbarui dengan data terbaru
      Get.snackbar(
        "Success",
        "$itemName removed from favorites",
        duration: const Duration(seconds: 1, milliseconds: 500),
        animationDuration: Duration.zero,
        backgroundColor: Colors.red[400]!
            .withOpacity(0.6),
        colorText: Colors.black,
        snackPosition: SnackPosition.TOP,
        borderRadius: 15,
      );
    }
  }

  Future<void> fetchFavorites() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !isGuest.value) {
      String userID = user.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('favorites')
          .snapshots()
          .listen((snapshot) {
        // Perbarui daftar lokal
        favorites.value = snapshot.docs.map((doc) {
          return FavoriteItem(
            id: doc.id,
            name: doc['itemName'],
            price: doc['itemPrice'],
          );
        }).toList();
        isFavorites
          ..clear()
          ..addAll(snapshot.docs.map((doc) => doc.id));
        update(); // Perbarui UI
      });
    } else {
      favorites.clear();
      isFavorites.clear();
    }
  }
}
