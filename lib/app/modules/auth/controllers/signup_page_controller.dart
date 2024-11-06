import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';
import 'package:sale_pisang_malang/app/modules/auth/views/login_page_view.dart';

class SignUpController extends GetxController {
  final AuthService _authService = AuthService();

  // Controllers untuk input
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Reactive variable untuk password visibility
  var isPasswordHidden = true.obs;

  // Form key untuk validasi form
  final formKey = GlobalKey<FormState>();

  // Fungsi untuk toggle visibilitas password
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Fungsi untuk melakukan registrasi
  Future<void> register() async {
    if (!formKey.currentState!.validate()) return; // Pastikan form valid

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      // Gunakan AuthService untuk registrasi
      await _authService.register(email, password, name);

      // Ambil UID pengguna setelah berhasil registrasi
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Simpan data pengguna di Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'role': email == 'adminpage@gmail.com' ? 'admin' : 'user',
      });

      // Redirect ke halaman StartPageView
      Get.offAll(() => LoginPageView());
      Get.snackbar("Registration Success", "Welcome, $name!");
    } catch (e) {
      Get.snackbar("Registration Failed", e.toString());
    }
  }
}
