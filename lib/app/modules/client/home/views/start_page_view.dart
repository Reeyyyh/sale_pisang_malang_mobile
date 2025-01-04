import 'package:curved_navigation_bar_with_label/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:sale_pisang_malang/app/modules/client/home/controllers/start_page_controller.dart';
import 'package:sale_pisang_malang/app/modules/client/page/1_Home/views/home_page_view.dart';
import 'package:sale_pisang_malang/app/modules/client/page/2_MyOrder/views/cart_page_view.dart';
import 'package:sale_pisang_malang/app/modules/client/page/3_Favorite/views/favorite_page_view.dart';
import 'package:sale_pisang_malang/app/modules/client/page/4_Profile/views/profile_page_view.dart';

class StartPageView extends StatelessWidget {
  const StartPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final StartPageController startController = Get.put(StartPageController());

    // Daftar halaman yang akan ditampilkan pada bottom navigation
    final List<Widget> pages = [
      const HomePageView(),
      const CartPageView(),
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
      'Cart',
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
              colors: [
                Color.fromRGBO(255, 255, 102, 1),
                Color.fromRGBO(255, 170, 0, 1),
                Color.fromRGBO(255, 239, 51, 1),
                Color.fromRGBO(255, 170, 0, 1),
                Color.fromRGBO(255, 204, 0, 1),
                Color.fromRGBO(255, 170, 0, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26, // Shadow color
                offset: Offset(0, -3), // Posisi bayangan ke atas
                blurRadius: 6, // Kelembutan bayangan
                spreadRadius: 1, // Ukuran penyebaran bayangan
              ),
            ],
          ),
          child: Obx(
            () => CurvedNavigationBar(
              height: 68,
              backgroundColor: Colors.transparent,
              buttonBackgroundColor:
                  const Color.fromARGB(146, 16, 18, 18), // Warna tombol
              buttonLabelColor: Colors.black,
              items: icons
                  .asMap()
                  .map((index, icon) => MapEntry(
                        index,
                        CurvedNavigationBarItem(
                          icon: Icon(icon,
                              size: 30,
                              color: startController.selectedIndex.value ==
                                      index
                                  ? Colors.white
                                  : Colors
                                      .grey), // Ubah warna ikon berdasarkan status
                          label: labels[index],
                        ),
                      ))
                  .values
                  .toList(),
              index: startController
                  .selectedIndex.value, // sinkronkan dengan controller
              onTap: (index) {
                startController.changePage(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
