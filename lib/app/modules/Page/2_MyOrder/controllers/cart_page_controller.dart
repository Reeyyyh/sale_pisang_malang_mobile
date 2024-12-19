import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/models/items_model.dart';
import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';

class CartPageController extends GetxController {
  var orders = <OrderModel>[].obs;
  var isGuest = false.obs;
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    checkUserStatus(); // Memeriksa status user
    if (!isGuest.value) {
      fetchOrders(); // Fetch data orders jika bukan guest
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

  // Fungsi untuk mengambil daftar cart dari Firestore
  void fetchOrders() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !isGuest.value) {
      String userID = user.uid;

      FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('cart') // Pastikan menggunakan koleksi cart
          .snapshots()
          .listen((snapshot) {
        orders.value = snapshot.docs.map((doc) {
          return OrderModel(
            id: doc.id,
            name: doc['itemName'],
            price: doc['itemPrice'],
            status: doc['itemStatus'], // Gunakan field status dari cart
          );
        }).toList();
        ;
        update(); // Update UI dengan data terbaru
      });
    } else {
      orders.clear(); // Jika user tidak login, kosongkan daftar orders
    }
  }

  // Fungsi untuk menghapus item dari cart
  Future<void> removeFromOrders(String orderId, String orderName) async {
    try {
      // Pastikan user sudah login
      if (_authService.currentUser != null) {
        // Hapus item dari Firestore (cart)
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_authService.currentUser!.uid)
            .collection('cart')
            .doc(orderId)
            .delete();

        // Optional: Perbarui daftar orders setelah item dihapus
        fetchOrders();
        Get.snackbar("Success", "$orderName removed from orders.");
      } else {
        Get.snackbar("Error", "Please login to remove items from orders.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to remove order: $e");
    }
  }
}
