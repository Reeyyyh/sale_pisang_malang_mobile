import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/home/views/start_page_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "sale_pisang_malang",
      home: StartPageView(),
    ),
  );
}
