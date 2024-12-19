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
    checkUserStatus();  // Memeriksa status user
    if (!isGuest.value) {
      fetchOrders();  // Fetch data orders jika bukan guest
    }
  }

  void checkUserStatus() {
    print("Checking user status...");
    if (_authService.isUserLoggedIn()) {
      isGuest.value = false;
      print("User is logged in.");
    } else {
      _authService.initializeGuestUser();
      isGuest.value = true;
      print("User is a guest.");
    }
  }

  // Fungsi untuk mengambil daftar cart dari Firestore
  void fetchOrders() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !isGuest.value) {
      String userID = user.uid;
      print("Fetching orders for user: $userID");

      FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('cart')  // Pastikan menggunakan koleksi cart
          .snapshots()
          .listen((snapshot) {
        print("Snapshot received: ${snapshot.docs.length} items");
        
        orders.value = snapshot.docs.map((doc) {
          print("Order ID: ${doc.id}, Name: ${doc['itemName']}, Price: ${doc['itemPrice']}, Status: ${doc['itemStatus']}");
          return OrderModel(
            id: doc.id,
            name: doc['itemName'],
            price: doc['itemPrice'],
            status: doc['itemStatus'],  // Gunakan field status dari cart
          );
        }).toList();
        print("Updated orders: ${orders.length}");
        update(); // Update UI dengan data terbaru
      });
    } else {
      orders.clear(); // Jika user tidak login, kosongkan daftar orders
      print("User is not logged in, clearing orders.");
    }
  }
}