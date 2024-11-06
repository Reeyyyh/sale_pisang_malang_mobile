import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/home/views/start_page_view.dart'; // Pastikan path ini sesuai dengan struktur proyek Anda

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void register() {
    // Implementasi logika registrasi
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      
      Get.offAll(() => const StartPageView());
    } else {
      Get.snackbar('Registration Failed', 'Please fill all fields',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
