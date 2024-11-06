import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/Page/4_Profile/controllers/profile_page_controller.dart';
import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';
import 'package:sale_pisang_malang/app/modules/home/views/start_page_view.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  final ProfileController _profileController = Get.put(ProfileController());

  // Deklarasi form key untuk validasi form
  final formKey = GlobalKey<FormState>();

  // Kontroller untuk email dan password
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Reactive variable untuk menyembunyikan password
  var isPasswordHidden = true.obs;

  // Fungsi untuk mengubah visibilitas password
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Fungsi login yang menerima email dan password
  void login(String email, String password) async {
    var user = await _authService.login(email, password);
    if (user != null) {
      _profileController.fetchUserData(); // Sinkronkan data pengguna
      Get.offAll(() => const StartPageView());
      Get.snackbar("Login Success", "Welcome back!");
    } else {
      Get.snackbar("Login Failed", "Invalid credentials. Try again.");
    }
  }
}
