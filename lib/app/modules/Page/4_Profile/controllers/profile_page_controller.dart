import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/Admin/views/admin_dashboard_page.dart';
import 'package:sale_pisang_malang/app/modules/auth/controllers/auth_controller.dart';
import 'package:sale_pisang_malang/app/modules/auth/views/login_page_view.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService();
  RxString role = ''.obs;
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;

  // Fungsi untuk login dan mendapatkan name dan role
  Future<void> login(String email, String password) async {
    var user = await _authService.login(email, password);
    if (user != null) {
      userEmail.value = user.email!;

      // Mendapatkan data pengguna (name dan role) dari Firestore
      var userData = await _authService.getUserData(user.uid);
      if (userData != null) {
        userName.value = userData['name']!;
        role.value = userData['role'] ?? 'user'; // Default ke 'user' jika role tidak ada
      }
    } else {
      Get.snackbar("Error", "Login failed. Check your credentials.");
    }
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    await _authService.logout();
    role.value = '';
    userName.value = '';
    userEmail.value = '';
    Get.offAll(() => LoginPageView());
  }

  // Fungsi untuk masuk ke Dashboard jika admin
  void goToAdminDashboard() {
    if (role.value == 'admin') {
      Get.offAll(() => const AdminDashboardView());
    } else {
      Get.snackbar("Access Denied", "You are not authorized to access the admin dashboard.");
    }
  }
}
