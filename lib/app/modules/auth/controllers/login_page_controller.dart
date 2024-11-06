import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/home/views/start_page_view.dart'; // Pastikan path sesuai

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void login() {
    if (formKey.currentState!.validate()) {
      // Cek validitas email dan password
      if (emailController.text == 'user@example.com' && passwordController.text == 'password') {
        // Jika berhasil, navigasi ke halaman HomePage
        Get.offAll(() => const StartPageView());
      } else {
        Get.snackbar('Login Failed', 'Invalid email or password',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  @override
  void onClose() {
    // Bersihkan controller saat tidak diperlukan lagi
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
