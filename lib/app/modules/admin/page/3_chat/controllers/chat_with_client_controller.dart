import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sale_pisang_malang/app/models/items_model.dart';

class ChatWithClientController extends GetxController {
  final String userId;
  var messages = <ChatMessage>[].obs;
  var userName = ''.obs;  // Menyimpan nama pengguna
  TextEditingController messageController = TextEditingController();

  ChatWithClientController({required this.userId});

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
    fetchUserName();  // Mengambil nama pengguna saat controller diinisialisasi
  }

  // Method untuk mengambil nama pengguna dari Firestore
  void fetchUserName() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        userName.value = docSnapshot.data()?['name'] ?? 'Unknown'; // Ambil nama user
      }
    });
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
      messages.value = snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc.data()))
          .toList();
    });
  }

  // Method untuk mengirim pesan
  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('chats')
          .add({
        'message': messageController.text,
        'sender': 'admin', // Admin yang mengirim pesan
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Setelah mengirim, bersihkan TextField
      messageController.clear();
    }
  }
}
