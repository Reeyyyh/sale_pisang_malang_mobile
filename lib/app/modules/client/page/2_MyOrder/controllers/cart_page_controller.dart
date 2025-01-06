import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/models/items_model.dart';
import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';

class CartPageController extends GetxController {
  var orders = <OrderModel>[].obs;
  var history = <HistoryModel>[].obs;
  var isGuest = false.obs;
  var activeTab = 0.obs; // Menyimpan tab yang aktif (default: Orders)

  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    checkUserStatus(); // Memeriksa status user
    if (!isGuest.value) {
      fetchOrders(); // Fetch data orders jika bukan guest
      fetchHistory(); // Fetch data history jika bukan guest
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

  void setActiveTab(int index) {
    activeTab.value = index;
  }

  // Fungsi untuk mengambil daftar cart dari Firestore
  Future<void> fetchOrders() async {
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
        update(); // Update UI dengan data terbaru
      });
    } else {
      orders.clear(); // Jika user tidak login, kosongkan daftar orders
    }
  }

  Future<void> fetchHistory() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userID = user.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('history') // Koleksi history
          .snapshots()
          .listen((snapshot) {
        history.value = snapshot.docs.map((doc) {
          return HistoryModel(
            id: doc.id, // Firestore akan memberikan ID otomatis
            name: doc['itemName'],
            price: doc['itemPrice'],
            timestamp: doc['timestamp'], // Pastikan timestamp ada di Firestore
          );
        }).toList();
        history.sort((a, b) => b.timestamp
            .compareTo(a.timestamp)); // Urutkan berdasarkan timestamp terbaru

        update(); // Update UI dengan data terbaru
      });
    } else {
      history.clear(); // Jika user tidak login, kosongkan daftar history
    }
  }

  Future<void> addToCart(ItemModel item) async {
    try {
      // Cek apakah pengguna sudah login
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userID = user.uid;

        // Menambahkan item ke dalam cart di Firestore
        Get.closeAllSnackbars();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .collection('cart')
            .doc(item.id) // ID item sebagai document ID
            .set({
          'id': item.id,
          'itemName': item.name,
          'itemPrice': item.harga,
          'itemStatus': 'Pending',
        });

        // Menampilkan notifikasi sukses
        Get.snackbar(
          'Success',
          'Item ${item.name} added to cart.',
          duration: const Duration(seconds: 1, milliseconds: 500),
          animationDuration: Duration.zero,
          backgroundColor: Colors.green[400]!.withOpacity(0.6),
          colorText: Colors.black,
          snackPosition: SnackPosition.TOP,
          borderRadius: 15,
        );

        // Memperbarui tampilan cart
        fetchOrders();
      } else {
        // Jika pengguna belum login
        Get.snackbar(
          'Login Required',
          'Please login to add item to cart',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Menangani error saat proses penyimpanan data
      Get.snackbar("Error", "Failed to add item to cart: $e");
    }
  }

  // Fungsi untuk menghapus item dari cart
  Future<void> removeFromOrders(String orderId, String orderName) async {
    try {
      // Pastikan user sudah login
      if (_authService.currentUser != null) {
        // Hapus item dari Firestore (cart)
        Get.closeAllSnackbars();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_authService.currentUser!.uid)
            .collection('cart')
            .doc(orderId)
            .delete();

        // Optional: Perbarui daftar orders setelah item dihapus
        fetchOrders();
        Get.snackbar(
          'Success',
          '$orderName remove from cart.',
          duration: const Duration(seconds: 1, milliseconds: 500),
          animationDuration: Duration.zero,
          backgroundColor: Colors.red[400]!.withOpacity(0.6),
          colorText: Colors.black,
          snackPosition: SnackPosition.TOP,
          borderRadius: 15,
        );
      } else {
        Get.snackbar("Error", "Please login to remove items from orders.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to remove order: $e");
    }
  }

  void deleteHistory(String historyId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userID = user.uid;

        // Menghapus dokumen history berdasarkan ID
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .collection('history')
            .doc(historyId)
            .delete();

        // Menghapus dari list history yang ditampilkan secara lokal
        history.removeWhere((item) => item.id == historyId);

        // Notifikasi sukses
        Get.snackbar(
          'Success',
          'history deleted succesfully',
          duration: const Duration(seconds: 1, milliseconds: 500),
          animationDuration: Duration.zero,
          backgroundColor: Colors.green[400]!.withOpacity(0.6),
          colorText: Colors.black,
          snackPosition: SnackPosition.TOP,
          borderRadius: 15,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete history: $e');
    }
  }

  // Fungsi untuk checkout dan memindahkan item ke history
  Future<void> checkoutOrders() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userID = user.uid;
      print(userID);

      try {
        // Ambil userName dari koleksi 'users' berdasarkan userID
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .get();

        if (userSnapshot.exists) {
          String userName = userSnapshot['name']; // Ambil nama pengguna

          for (var order in orders) {
            try {
              // Menyimpan riwayat pesanan di koleksi history dengan ID otomatis
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userID)
                  .collection('history')
                  .add({
                'itemName': order.name,
                'itemPrice': order.price,
                'itemStatus': order.status,
                'timestamp':
                    FieldValue.serverTimestamp(), // Menambahkan timestamp
              });

              // Menambahkan pesanan ke koleksi checkout (di luar user)
              await FirebaseFirestore.instance.collection('checkout').add({
                'userID': userID,
                'userName': userName, // Menambahkan userName
                'orderDetails': [
                  {
                    'itemName': order.name,
                    'itemPrice': order.price,
                    'itemStatus': order.status
                  }
                ],
                'timestamp': FieldValue.serverTimestamp(),
              });

              // Menghapus item dari cart setelah checkout
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userID)
                  .collection('cart')
                  .doc(order.id)
                  .delete();
            } catch (e) {
              Get.snackbar("Error", "Failed to checkout: $e");
            }
          }

          // Setelah checkout, perbarui status hasOrders
          orders.clear(); // Kosongkan daftar orders

          // Setelah checkout, kamu bisa memperbarui tampilan
          fetchHistory();
          fetchOrders();

          // Menampilkan notifikasi sukses
          Get.snackbar(
            'Success',
            'Orders checked out successfully',
            duration: const Duration(seconds: 1, milliseconds: 500),
            animationDuration: Duration.zero,
            backgroundColor: Colors.green[400]!.withOpacity(0.6),
            colorText: Colors.black,
            snackPosition: SnackPosition.TOP,
            borderRadius: 15,
          );
        }
      } catch (e) {
        Get.snackbar("Error", "Failed to fetch user data: $e");
      }
    }
  }
}
