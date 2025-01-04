import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sale_pisang_malang/app/modules/admin/page/3_chat/controllers/chat_with_client_controller.dart';

class ChatWithClientView extends StatelessWidget {
  final String userId;
  const ChatWithClientView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Menginisialisasi controller dengan GetX
    final controller = Get.put(ChatWithClientController(userId: userId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          // Menampilkan nama pengguna di AppBar
          return Text(
            controller.userName.value.isNotEmpty
                ? controller.userName.value
                : 'Loading...',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }),
        backgroundColor: const Color.fromRGBO(255, 170, 0, 1),
      ),
      body: Column(
        children: [
          // Area chat
          Expanded(
            child: Obx(
              () {
                if (controller.messages.isEmpty) {
                  return FutureBuilder(
                    future: Future.delayed(
                        const Duration(seconds: 1, milliseconds: 500)),
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
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final chatMessage = controller.messages[index];
                    final isAdmin = chatMessage.sender ==
                        controller.adminId; // Periksa berdasarkan UID admin

                    // Format timestamp
                    final formattedTime =
                        DateFormat('HH:mm').format(chatMessage.timestamp);
                    final formattedDate =
                        DateFormat('dd MMM yyyy').format(chatMessage.timestamp);

                    // Cek apakah tanggal sebelumnya berbeda dengan tanggal saat ini
                    String? displayDate;
                    if (index == 0) {
                      // Tampilkan tanggal untuk pesan pertama
                      displayDate = formattedDate;
                    } else {
                      final previousMessage = controller.messages[index - 1];
                      final previousDate = DateFormat('dd MMM yyyy')
                          .format(previousMessage.timestamp);
                      if (formattedDate != previousDate) {
                        displayDate =
                            formattedDate; // Tampilkan tanggal jika berbeda
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
                          alignment: isAdmin
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                            // Menambahkan padding di sekitar bubble chat
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0), // Padding horizontal
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5.0),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isAdmin
                                    ? const Color.fromRGBO(255, 170, 0, 1)
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: isAdmin
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    chatMessage.message,
                                    style: TextStyle(
                                      color:
                                          isAdmin ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formattedTime, // Menampilkan waktu yang sudah diformat
                                    style: TextStyle(
                                      color: isAdmin
                                          ? Colors.white70
                                          : Colors.black54,
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
              },
            ),
          ),

          // Input pesan
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
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
