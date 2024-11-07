import 'package:curved_navigation_bar_with_label/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sale_pisang_malang/app/modules/Page/1_Home/views/home_page_view.dart';
import 'package:sale_pisang_malang/app/modules/Page/2_MyOrder/views/my_order_page_view.dart';
import 'package:sale_pisang_malang/app/modules/Page/3_Favorite/views/favorite_page_view.dart';
import 'package:sale_pisang_malang/app/modules/Page/4_Profile/views/profile_page_view.dart';
import 'package:sale_pisang_malang/app/modules/home/controllers/start_page_controller.dart';

class StartPageView extends StatelessWidget {
  const StartPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final StartPageController startController = Get.put(StartPageController());

    // Daftar halaman yang akan ditampilkan pada bottom navigation
    final List<Widget> pages = [
      const HomePageView(),
      const MyOrderPageView(),
      const FavoritePageView(),
      const ProfilePageView(),
    ];

    // Daftar ikon yang akan digunakan pada bottom navigation
    final List<IconData> icons = [
      Icons.home,
      Icons.shopping_cart,
      Icons.favorite,
      Icons.person,
    ];

    // Daftar label yang ditampilkan di bawah ikon
    final List<String> labels = [
      'Home',
      'My Order',
      'Favorite',
      'Profile',
    ];

    return Scaffold(
      body: Obx(() {
        // Menampilkan halaman sesuai dengan indeks yang dipilih
        return pages[startController.selectedIndex.value];
      }),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purpleAccent, Colors.yellowAccent, Colors.redAccent, Colors.blueAccent], // Ungu ke Biru
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Obx(() => CurvedNavigationBar(
                height: 68,
                backgroundColor: Colors.transparent,
                buttonBackgroundColor: const Color.fromARGB(168, 98, 183, 183), // Warna tombol
                buttonLabelColor: Colors.black,
                items: icons
                    .asMap()
                    .map((index, icon) => MapEntry(
                          index,
                          CurvedNavigationBarItem(
                            icon: Icon(icon, size: 30, color: Colors.black),
                            label: labels[index],
                          ),
                        ))
                    .values
                    .toList(),
                index: startController.selectedIndex.value, // sinkronkan dengan controller
                onTap: (index) {
                  startController.changePage(index);
                },
              )),
        ),
      ),
    );
  }
}
