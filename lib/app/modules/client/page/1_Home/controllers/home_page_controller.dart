import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sale_pisang_malang/app/models/items_model.dart';


import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';
import 'package:sale_pisang_malang/app/modules/client/page/2_MyOrder/controllers/cart_page_controller.dart';
import 'package:sale_pisang_malang/app/modules/client/page/3_Favorite/controllers/favorite_page_controller.dart';
import 'package:sale_pisang_malang/app/modules/client/page/4_Profile/controllers/profile_page_controller.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FavoriteController _favoriteController = Get.put(FavoriteController());
  final CartPageController _cartController = Get.put(CartPageController());

  final ProfileController _profileController = Get.put(ProfileController());

  RxBool get isUserGuest =>
      RxBool(_authService.currentUserData?['role'] == 'guest');

  var items = <ItemModel>[].obs;
  var isLoggedIn = false.obs;
  var isLoading = true.obs;
  var hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
    checkUserStatus();
    if (!isUserGuest.value) {
      fetchFavorites(); // Fetch favorites jika pengguna bukan guest
    }
    startLoadingTimeout();
    _profileController.fetchUserData();
  }

  void fetchItems() {
    FirebaseFirestore.instance
        .collection('items')
        .snapshots()
        .listen((snapshot) {
      items.value =
          snapshot.docs.map((doc) => ItemModel.fromDocument(doc)).toList();
      isLoading.value = false;
      hasError.value = items.isEmpty;
    });
  }

  void fetchFavorites() async {
    if (isUserGuest.value) {
      return; // Tidak mengambil data favorit jika user adalah guest
    }

    // Mengambil data dari FavoriteController
    _favoriteController.fetchFavorites();

    _favoriteController.favorites.map((item) => item.id).toSet();
  }

  // Todo :  add data
  Future<void> addToCart(ItemModel item) async {
    if (isUserGuest.value) {
      checkUserAccess('Cart');
      return;
    }
    await _cartController.addToCart(item);
  }

  Future<void> addToFavorites(ItemModel item) async {
    if (isUserGuest.value) {
      checkUserAccess('Favorites');
      return;
    }
    await _favoriteController.addToFavorites(item);
  }
  

  // Todo : Remove data
  Future<void> removeFromFavorites(String itemId, String itemName) async {
    if (isUserGuest.value) {
      checkUserAccess('Favorites');
      return;
    }
    await _favoriteController.removeFromFavorites(itemId, itemName);
  }

  void startLoadingTimeout() {
    Future.delayed(const Duration(seconds: 1), () {
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

  // bool get isUserGuest => _authService.currentUserData?['role'] == 'guest';
  // Ubah isUserGuest menjadi RxBool agar dapat diobservasi.

  void checkUserAccess(String featureName) {
    if (isUserGuest.value) {
      Get.snackbar(
        'Login Required',
        'Please login to add item in $featureName',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  RxBool isItemInFavorites(String itemId) {
    return RxBool(_favoriteController.isFavorites.contains(itemId));
  }
}
