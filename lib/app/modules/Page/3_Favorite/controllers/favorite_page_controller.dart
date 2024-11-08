import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/models/items_model.dart';
import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';

class FavoriteController extends GetxController {
  var favorites = <FavoriteItem>[].obs;
  var isGuest = false.obs;
  final AuthService _authService = Get.find<AuthService>();

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

  void fetchFavorites() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !isGuest.value) {
      String userID = user.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('favorites')
          .snapshots()
          .listen((snapshot) {
        favorites.value = snapshot.docs.map((doc) {
          return FavoriteItem(
            id: doc.id,
            name: doc['itemName'],
            price: doc['itemPrice'],
          );
        }).toList();
        update();
      });
    } else {
      favorites.clear();
    }
  }
}
