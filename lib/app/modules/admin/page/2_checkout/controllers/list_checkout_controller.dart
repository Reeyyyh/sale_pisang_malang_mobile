import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListCheckoutController extends GetxController {
  var checkoutData = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    listenToCheckoutData(); // Mendengarkan data checkout secara real-time
  }

  // Fungsi untuk mendengarkan data checkout secara real-time
  void listenToCheckoutData() {
    isLoading(true); // Set loading saat mulai mendengarkan data
    FirebaseFirestore.instance.collection('checkout').snapshots().listen(
      (snapshot) {
        checkoutData.value = snapshot.docs.map((doc) {
          return {
            'docId': doc.id, // Ambil ID dokumen untuk keperluan penghapusan
            'userName': doc['userName'],
            'orderDetails': doc['orderDetails'],
            'timestamp': doc['timestamp'], // Pastikan timestamp ada
          };
        }).toList();
        isLoading(false); // Data telah dimuat
      },
      onError: (error) {
        isLoading(false); // Set loading ke false jika terjadi error
        print("Error listening to checkout data: $error");
        Get.snackbar(
          'Error',
          'Failed to load checkout data.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  void refreshCheckoutData() {
    FirebaseFirestore.instance.collection('checkout').get().then((snapshot) {
      checkoutData.value = snapshot.docs.map((doc) {
        return {
          'docId': doc.id,
          'userName': doc['userName'],
          'orderDetails': doc['orderDetails'],
          'timestamp': doc['timestamp'],
        };
      }).toList();
    });
  }

  // Fungsi untuk menghapus item checkout
  void deleteCheckoutItem(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('checkout')
          .doc(docId)
          .delete();
      refreshCheckoutData(); // Sinkronkan ulang data
      Get.snackbar(
        'Success',
        'Item has been deleted successfully.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white.withOpacity(0.6),
        duration: const Duration(seconds: 1, milliseconds: 500),
        animationDuration: Duration.zero,
        borderRadius: 15,
      );
    } catch (e) {
      print("Error deleting checkout item: $e");
      Get.snackbar(
        'Error',
        'Failed to delete item.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
