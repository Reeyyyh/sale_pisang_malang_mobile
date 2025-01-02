import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar_with_label/curved_navigation_bar.dart';
import 'package:sale_pisang_malang/app/modules/admin/home/controllers/admin_page_controller.dart';
import 'package:sale_pisang_malang/app/modules/admin/page/1_dashboard/views/dashboard_page_view.dart';
import 'package:sale_pisang_malang/app/modules/admin/page/3_chat/views/admin_chat_page_view.dart';
import 'package:sale_pisang_malang/app/modules/admin/page/4_profile/views/profile_page_view.dart';

class AdminPageView extends StatelessWidget {
  const AdminPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminPageController adminController = Get.put(AdminPageController());

    // Daftar halaman untuk navigasi
    final List<Widget> pages = [
      const DashboardPageView(),
      const ListCheckoutPage(),
      const AdminChatPageView(),
      const ProfilePageView(),
    ];

    // Daftar ikon dan label untuk navbar
    final List<IconData> icons = [
      Icons.dashboard,
      Icons.shopping_basket,
      Icons.chat,
      Icons.person,
    ];

    final List<String> labels = [
      'Dashboard',
      'Order',
      'Chat',
      'Profile',
    ];

    return Scaffold(
      body: Obx(() {
        // Menampilkan halaman sesuai indeks yang dipilih
        return pages[adminController.selectedIndex.value];
      }),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(182, 255, 250, 1),
                Color.fromRGBO(152, 228, 255, 1),
                Color.fromRGBO(128, 179, 255, 1),
                Color.fromRGBO(104, 126, 255, 1),
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
              buttonBackgroundColor: const Color.fromARGB(146, 16, 18, 18),
              buttonLabelColor: Colors.black,
              items: icons
                  .asMap()
                  .map((index, icon) => MapEntry(
                        index,
                        CurvedNavigationBarItem(
                          icon: Icon(
                            icon,
                            size: 30,
                            color: adminController.selectedIndex.value == index
                                ? Colors.white
                                : Colors.grey,
                          ),
                          label: labels[index],
                        ),
                      ))
                  .values
                  .toList(),
              index: adminController.selectedIndex.value,
              onTap: (index) {
                adminController.changePage(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ListCheckoutPage extends StatelessWidget {
  const ListCheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('List Order Page'),
    );
  }
}