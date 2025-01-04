import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sale_pisang_malang/app/models/items_model.dart';

class ChatWithClientController extends GetxController {
  final String userId;
  final String adminId = FirebaseAuth.instance.currentUser?.uid ?? '';

  var messages = <ChatMessage>[].obs;
  var userName = ''.obs; // Menyimpan nama pengguna
  TextEditingController messageController = TextEditingController();

  ChatWithClientController({required this.userId});

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
    fetchUserName(); // Mengambil nama pengguna saat controller diinisialisasi
  }

  // Method untuk mengambil nama pengguna dari Firestore
  void fetchUserName() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        userName.value =
            docSnapshot.data()?['name'] ?? 'Unknown'; // Ambil nama user
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
    // Periksa apakah admin sudah login dan memiliki userId
    final adminId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (adminId.isEmpty) {
      // Tangani jika admin belum login (opsional)
      Get.snackbar('Error', 'Anda harus login untuk mengirim pesan');
      return;
    }

    // Pastikan pesan tidak kosong
    final message = messageController.text.trim();
    if (message.isEmpty) return;

    // Buat objek ChatMessage
    final newMessage = ChatMessage(
      message: message,
      sender: adminId, // Gunakan adminId sebagai sender
      timestamp: DateTime.now(),
    );

    // Simpan pesan ke Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId) // Ini adalah userId dari pengguna yang sedang di-chat
        .collection('chats')
        .add(newMessage.toFirestore());

    // Bersihkan input field setelah mengirim pesan
    messageController.clear();
    Get.focusScope?.unfocus();
  }
}
