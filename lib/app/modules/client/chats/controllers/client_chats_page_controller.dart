import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sale_pisang_malang/app/models/items_model.dart';

class ClientChatsPageController extends GetxController {
  
  RxList<ChatMessage> messages = <ChatMessage>[].obs; // Gunakan model ChatMessage
  TextEditingController messageController = TextEditingController();

  final String userId;

  ClientChatsPageController({required this.userId});

  @override
  void onInit() {
    super.onInit();
    fetchMessages(); // Ambil pesan saat pertama kali masuk
  }

  // Method untuk mengambil pesan dari Firestore
  void fetchMessages() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chats')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs.map((doc) {
        return ChatMessage.fromFirestore(doc.data());
      }).toList();
    });
  }

  // Method untuk mengirim pesan
  void sendMessage() async {
    final message = messageController.text;
    if (message.isEmpty) return;

    final newMessage = ChatMessage(
      message: message,
      sender: userId,
      timestamp: DateTime.now(),
    );

    // Simpan pesan ke Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chats')
        .add(newMessage.toFirestore());

    messageController.clear(); // Bersihkan input field setelah mengirim pesan
    Get.focusScope?.unfocus();
  }
}
