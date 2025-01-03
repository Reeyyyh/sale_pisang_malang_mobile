import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/admin/home/views/admin_page_view.dart';
import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';
import 'package:sale_pisang_malang/app/modules/client/home/views/start_page_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Inisialisasi AuthService
  Get.put(AuthService());

  // Periksa status login saat aplikasi mulai
  final user = FirebaseAuth.instance.currentUser;
  Widget initialPage;

  if (user != null) {
    // Jika ada user yang login, periksa role-nya
    final userData = await Get.find<AuthService>().getUserData(user.uid);
    final role = userData?['role'] ?? 'user';

    if (role == 'admin') {
      initialPage = const AdminPageView();
    } else {
      initialPage = const StartPageView();
    }
  } else {
    // Jika tidak ada user yang login
    initialPage = const StartPageView();
  }

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sale Pisang Malang",
      home: initialPage,
    ),
  );
}
