import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Untuk format waktu
import 'package:sale_pisang_malang/app/models/items_model.dart';
import 'package:sale_pisang_malang/app/modules/client/chats/controllers/client_chats_page_controller.dart';

class ClientChatsAdminPageView extends StatelessWidget {
  final String userId;

  const ClientChatsAdminPageView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final ClientChatsPageController controller = Get.put(ClientChatsPageController(userId: userId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Chat Dengan Admin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Area chat
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                // Menunggu beberapa detik sebelum menampilkan pesan "Belum ada pesan."
                return FutureBuilder(
                  future: Future.delayed(const Duration(seconds: 1, milliseconds: 500)), // 1.5 detik
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return const Center(child: Text('Belum ada pesan.'));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final ChatMessage message = controller.messages[index];
                  final bool isUser = message.sender == userId;

                  // Format waktu menjadi jam:menit
                  final String formattedTime = DateFormat('HH:mm').format(message.timestamp);
                  final String formattedDate = DateFormat('dd MMM yyyy').format(message.timestamp);

                  // Cek apakah tanggal sebelumnya berbeda dengan tanggal saat ini
                  String? displayDate;
                  if (index == 0) {
                    displayDate = formattedDate; // Tampilkan tanggal untuk pesan pertama
                  } else {
                    final ChatMessage previousMessage = controller.messages[index - 1];
                    final String previousDate = DateFormat('dd MMM yyyy').format(previousMessage.timestamp);
                    if (formattedDate != previousDate) {
                      displayDate = formattedDate; // Tampilkan tanggal jika berbeda
                    }
                  }

                  return Column(
                    children: [
                      if (displayDate != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            displayDate,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: isUser ? Colors.blueAccent : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.message,
                                  style: TextStyle(
                                    color: isUser ? Colors.white : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  formattedTime,
                                  style: TextStyle(
                                    color: isUser ? Colors.white : Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
          // Input pesan
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: controller.sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
