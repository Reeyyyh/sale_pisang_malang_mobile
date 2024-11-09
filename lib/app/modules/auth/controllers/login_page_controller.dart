import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/Page/4_Profile/controllers/profile_page_controller.dart';
import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';
import 'package:sale_pisang_malang/app/modules/home/views/start_page_view.dart';


class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>(); 
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Fungsi login
  void login(String email, String password) async {
    try {
      var user = await _authService.login(email, password);
      if (user != null) {
        Get.find<ProfileController>().fetchUserData();
        Get.offAll(() => const StartPageView());
        Get.snackbar("Login Success", "Welcome back!");
      }
    } catch (e) {
      Get.snackbar(
        "Login Failed",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
