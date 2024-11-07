import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sale_pisang_malang/app/models/items_model.dart';
import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';

class HomeController extends GetxController {
  var items = <ItemModel>[].obs;
  final AuthService _authService = Get.find<AuthService>();
  
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
    checkUserStatus();
  }

  void fetchItems() {
    FirebaseFirestore.instance.collection('items').snapshots().listen((snapshot) {
      items.value = snapshot.docs.map((doc) => ItemModel.fromDocument(doc)).toList();
    });
  }

  void checkUserStatus() {
    // Periksa apakah ada user yang login
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
}
