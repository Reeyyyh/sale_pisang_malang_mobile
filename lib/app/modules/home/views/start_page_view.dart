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

    final List<Widget> pages = [
      const HomePageView(),
      const MyOrderPageView(),
      const FavoritePageView(),
      const ProfilePageView(),
    ];

    return Scaffold(
      body: Obx(() {
        return pages[startController.selectedIndex.value];
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: startController.selectedIndex.value,
          onTap: startController.changePage,
          selectedItemColor: Colors.orangeAccent,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          iconSize: 30,
          elevation: 5,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'My Order',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
