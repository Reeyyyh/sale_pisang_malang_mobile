import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/Admin/views/admin_dashboard_page.dart';
import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';
import 'package:sale_pisang_malang/app/modules/auth/views/login_page_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  RxString role = ''.obs;
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;

  // Fungsi untuk mengambil data pengguna setelah login
  Future<void> fetchUserData() async {
    var user = _authService.currentUser;
    if (user != null) {
      var userData = await _authService.getUserData(user.uid);
      if (userData != null) {
        userName.value = userData['name'] ?? 'Guest';
        role.value = userData['role'] ?? 'user';
        userEmail.value = userData['email'] ?? '';
      }
    } else {
      // Jika pengguna belum login, set role ke kosong dan nama ke 'Guest'
      role.value = '';
      userName.value = 'Guest';
      userEmail.value = '';
    }
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    await _authService.logout();
    role.value = '';
    userName.value = 'Guest';
    userEmail.value = '';
    Get.offAll(() => LoginPageView());
  }

  // Fungsi untuk menuju ke dashboard admin
  void goToAdminDashboard() {
    if (role.value == 'admin') {
      Get.offAll(() => const AdminDashboardView());
    } else {
      Get.snackbar("Access Denied", "You are not authorized to access the admin dashboard.");
    }
  }


  // Fungsi untuk membuka Instagram
  void goToInstagram() async {
    final Uri instagramUrl = Uri.parse('https://www.instagram.com/salepisangmalang/'); // Ganti dengan URL Instagram yang diinginkan
    if (await canLaunchUrl(instagramUrl)) {
      await launchUrl(instagramUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not launch Instagram.');
    }
  }

  // Fungsi untuk membuka Shopee
  void goToShopee() async {
    final Uri shopeeUrl = Uri.parse('https://shopee.co.id/salepisang_malang?entryPoint=ShopByPDP'); // Ganti dengan URL Shopee yang diinginkan
    if (await canLaunchUrl(shopeeUrl)) {
      await launchUrl(shopeeUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not launch Shopee.');
    }
  }

  // Fungsi untuk membuka Tokopedia
  void goToTokopedia() async {
    final Uri tokopediaUrl = Uri.parse('https://www.tokopedia.com/salepisangm'); // Ganti dengan URL Tokopedia yang diinginkan
    if (await canLaunchUrl(tokopediaUrl)) {
      await launchUrl(tokopediaUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not launch Tokopedia.');
    }
  }
}
