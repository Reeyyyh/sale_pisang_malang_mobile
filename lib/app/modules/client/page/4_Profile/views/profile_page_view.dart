import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/components/component.dart';
import 'package:sale_pisang_malang/app/modules/auth/views/login_page_view.dart';
import 'package:sale_pisang_malang/app/modules/auth/views/signup_page_view.dart';
import 'package:sale_pisang_malang/app/modules/client/page/4_Profile/controllers/profile_page_controller.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    // Panggil fungsi untuk mendapatkan data pengguna ketika halaman pertama kali dibuka
    profileController.fetchUserData();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Stack(
          children: [
            Positioned.fill(
              child: Transform.scale(
                scale: 1.10,
                child: ClipPath(
                  clipper: AppBarClipper(),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
            ),
            ClipPath(
              clipper: AppBarClipper(),
              child: AppBar(
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.blueAccent,
                actions: [
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const FaIcon(
                          Icons.menu_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        width: 250,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Hero(
                    tag: 'drawerToAppBarHero',
                    child: Container(
                      height: 100,
                      color: Colors.blueAccent,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: const Center(
                        child: Text(
                          'Menu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(() {
                    if (profileController.role.value.isEmpty) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey, // Warna border
                                  width: 1.0, // Ketebalan border
                                ),
                                borderRadius: BorderRadius.circular(
                                    8.0), // Sudut melengkung
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.login, size: 30),
                                title: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Get.to(() => LoginPageView())
                                      ?.then((_) async {
                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                    Get.offAll(() => LoginPageView());
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey, // Warna border
                                  width: 1.0, // Ketebalan border
                                ),
                                borderRadius: BorderRadius.circular(
                                    8.0), // Sudut melengkung
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.app_registration,
                                    size: 30),
                                title: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Get.to(() => SignUpPageView())
                                      ?.then((_) async {
                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                    Get.offAll(() => SignUpPageView());
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey, // Warna border
                              width: 1.0, // Ketebalan border
                            ),
                            borderRadius:
                                BorderRadius.circular(8.0), // Sudut melengkung
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            title: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              profileController.logout();
                            },
                          ),
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF2A2A2A),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => {profileController.goToInstagram()},
                    child: Image.asset(
                      width: 35,
                      height: 35,
                      'assets/icons/Instagram_icon.png',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {profileController.goToShopee()},
                    child: Image.asset(
                      width: 40,
                      height: 40,
                      'assets/icons/Shopee_icon.png',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {profileController.goToTokopedia()},
                    child: Image.asset(
                      width: 40,
                      height: 40,
                      'assets/icons/Tokopedia_icon.png',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {profileController.goToTiktok()},
                    child: Image.asset(
                      width: 40,
                      height: 40,
                      'assets/icons/Tiktok_icon.png',
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/img/logo.jpg'),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Center(
                child: Text(
                  profileController.role.value.isEmpty
                      ? 'Welcome Guest'
                      : profileController.userName.value,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => profileController.role.value.isNotEmpty
                ? Center(
                    child: Text(
                      profileController.userEmail.value,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : Container()),
            const SizedBox(height: 16),
            const Divider(),
            Obx(
              () {
                if (profileController.role.value.isNotEmpty) {
                  return ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 40),
                    ),
                  );
                }
                return Container();
              },
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 7,
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {},
              ),
            ),
            Card(
              elevation: 7,
              child: ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                onTap: () {},
              ),
            ),
            Card(
              elevation: 7,
              child: ListTile(
                leading: const Icon(Icons.announcement_outlined),
                title: const Text('About app'),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'sale pisang malang',
                    applicationLegalese: 'Thank you for choosing us',
                    applicationIcon: const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/img/logo.jpg'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
