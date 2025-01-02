import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';
import 'package:sale_pisang_malang/app/modules/auth/views/login_page_view.dart';

class SignUpController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordHidden = true.obs;
  final signUpFormKey  = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> register() async {
    if (!signUpFormKey.currentState!.validate()) return;

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      await _authService.register(name, email, password);
      Get.offAll(() => LoginPageView());
      Get.snackbar("Registration Success", "Welcome, $name!");
    } catch (e) {
      print('Registrasi gagal: ${e.toString()}');
      Get.snackbar("Registration Failed", e.toString());
    }
  }
}