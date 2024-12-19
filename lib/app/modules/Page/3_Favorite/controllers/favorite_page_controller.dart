import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/models/items_model.dart';
import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';

class FavoriteController extends GetxController {
  var isGuest = false.obs;
  final AuthService _authService = Get.find<AuthService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<FavoriteItem> favorites = <FavoriteItem>[].obs; // List untuk menyimpan item favorit

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

  // Fungsi untuk menghapus item dari daftar favorit
Future<void> removeFromFavorites(String itemId, String itemName) async {
  try {
    // Pastikan user sudah login
    if (_authService.currentUser != null) {
      await _firestore
          .collection('users')
          .doc(_authService.currentUser!.uid)
          .collection('favorites')
          .doc(itemId)
          .delete();

      // Optional: Perbarui list favorit setelah item dihapus
      fetchFavorites();
      Get.snackbar("Success", "$itemName removed from favorites.");
    } else {
      Get.snackbar("Error", "Please login to remove items from favorites.");
    }
  } catch (e) {
    Get.snackbar("Error", "Failed to remove item: $e");
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
        // Mengubah data snapshot menjadi list FavoriteItem
        favorites.value = snapshot.docs.map((doc) {
          return FavoriteItem(
            id: doc.id,
            name: doc['itemName'],
            price: doc['itemPrice'],
          );
        }).toList();
        update(); // Update UI dengan data terbaru
      });
    } else {
      favorites.clear(); // Jika user tidak login, kosongkan daftar favorit
    }
  }
}
