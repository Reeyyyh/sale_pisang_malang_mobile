import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ClientChatsPageController extends GetxController {
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
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
        return {
          'sender': doc['sender'],
          'message': doc['message'],
          'timestamp': doc['timestamp'].toDate(),
        };
      }).toList();
    });
  }

  // Method untuk mengirim pesan
  void sendMessage() async {
    final message = messageController.text;
    if (message.isEmpty) return;

    // Simpan pesan ke Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chats')
        .add({
      'sender': userId, // ID user
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    messageController.clear(); // Bersihkan input field setelah mengirim pesan
  }
}
