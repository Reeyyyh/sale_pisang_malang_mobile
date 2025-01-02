import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';
import 'package:sale_pisang_malang/app/modules/client/home/views/start_page_view.dart';
import 'package:sale_pisang_malang/app/modules/client/page/3_Favorite/controllers/favorite_page_controller.dart';
import 'package:sale_pisang_malang/app/modules/client/page/4_Profile/controllers/profile_page_controller.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isPasswordHidden = true.obs;

  final loginFormKey  = GlobalKey<FormState>();
  
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Fungsi login
  Future<void> login() async {
    if (loginFormKey .currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      try {
        // Menggunakan AuthService untuk login
        var user = await _authService.login(email, password);

        if (user != null) {
          // Mengambil data pengguna setelah login berhasil
          await Get.find<FavoriteController>().fetchFavorites();
          await Get.find<ProfileController>().fetchUserData();

          // Navigasi ke halaman utama
          Get.offAll(() => const StartPageView());

          // Snackbar sukses
          Get.snackbar(
            "Login Success",
            "Welcome back, ${_authService.currentUserData?['name'] ?? 'User'}!",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.greenAccent,
            colorText: Colors.black,
          );
        }
      } catch (e) {
        // Tangani kesalahan login
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
}
