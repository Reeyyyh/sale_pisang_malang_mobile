import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/admin/page/3_chat/views/chat_with_client_view.dart';

class AdminChatPageController extends GetxController {
  // Reactive variable untuk menyimpan data pengguna
  var users = <QueryDocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  // Method untuk mengambil data pengguna dari Firestore
  void fetchUsers() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
      
      // Filter untuk menghindari pengguna dengan role 'admin'
      users.value = snapshot.docs.where((doc) {
        // Memeriksa apakah pengguna bukan admin
        return doc['role'] != 'admin';
      }).toList();  // Hanya memasukkan user yang bukan admin
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  // Method untuk menavigasi ke halaman chat
  void goToChat(String userId) {
    Get.to(() => ChatWithClientView(userId: userId));
  }
}
