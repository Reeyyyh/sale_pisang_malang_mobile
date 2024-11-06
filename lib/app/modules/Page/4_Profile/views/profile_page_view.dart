import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/Page/4_Profile/controllers/profile_page_controller.dart';
import 'package:sale_pisang_malang/app/modules/auth/views/login_page_view.dart';
import 'package:sale_pisang_malang/app/modules/auth/views/register_page_view.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 120,
              color: Theme.of(context).primaryColor,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Obx(() {
              if (profileController.role.value.isEmpty) {
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.login),
                      title: const Text('Login'),
                      onTap: () {
                        Navigator.pop(context);
                        Get.offAll(() => LoginPageView());
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.app_registration),
                      title: const Text('Register'),
                      onTap: () {
                        Navigator.pop(context);
                        Get.offAll(() => RegisterPageView());
                      },
                    ),
                  ],
                );
              } else {
                return ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    profileController.logout();
                  },
                );
              }
            }),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/img/logo.jpg'),
            ),
            const SizedBox(height: 16),
            // Menampilkan nama pengguna atau "Guest" jika belum login
            Obx(() => Text(
                  profileController.role.value.isEmpty
                      ? 'Welcome Guest'
                      : profileController.userName.value,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 8),
            // Menampilkan email jika sudah login
            Obx(() => profileController.role.value.isNotEmpty
                ? Text(
                    profileController.userEmail.value,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  )
                : Container()),
            const SizedBox(height: 24),
            if (profileController.role.value == 'admin')
              ElevatedButton.icon(
                onPressed: profileController.goToAdminDashboard,
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text('Admin Dashboard'),
              ),
            const SizedBox(height: 16),
            // if (profileController.role.value.isNotEmpty)
            //   ElevatedButton.icon(
            //     onPressed: profileController.logout,
            //     icon: const Icon(Icons.logout),
            //     label: const Text('Logout'),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.redAccent,
            //       minimumSize: const Size(double.infinity, 40),
            //     ),
            //   ),
            const SizedBox(height: 24),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & Support'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
