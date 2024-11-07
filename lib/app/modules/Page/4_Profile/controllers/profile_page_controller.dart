// profile_controller.dart
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/Admin/views/admin_dashboard_page.dart';
import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';
import 'package:sale_pisang_malang/app/modules/auth/views/login_page_view.dart';


class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  RxString role = ''.obs;
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;

  Future<void> fetchUserData() async {
    var user = _authService.currentUser;
    if (user != null) {
      var userData = await _authService.getUserData(user.uid);
      if (userData != null) {
        userName.value = userData['name'] ?? 'Guest';
        role.value = userData['role'] ?? 'user';
        userEmail.value = userData['email'] ?? '';
      }
    }
  }

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
