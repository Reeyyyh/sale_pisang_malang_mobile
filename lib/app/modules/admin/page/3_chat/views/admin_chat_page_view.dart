import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/admin/page/3_chat/controllers/admin_chat_page_controller.dart';

class AdminChatPageView extends StatelessWidget {
  const AdminChatPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // Menginisialisasi controller GetX
    final controller = Get.put(AdminChatPageController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chats Dengan User',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(
        () {
          // Menggunakan Obx untuk merespon perubahan data 'users'
          if (controller.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.only(top: 10), // Jarak 10dp dari atas
            child: ListView.builder(
              itemCount: controller.users.length,
              itemBuilder: (context, index) {
                final user = controller.users[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius:
                        20, // Tambahkan atau sesuaikan radius untuk memperbesar
                    child: Text(
                      user['name'][0].toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18), // Perbesar font agar proporsional
                    ),
                  ),
                  title: Text(user['name']),
                  onTap: () {
                    // Menggunakan controller untuk menavigasi
                    controller.goToChat(user.id);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
