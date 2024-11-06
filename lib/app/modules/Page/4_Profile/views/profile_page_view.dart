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
          // Tombol untuk membuka Drawer di sebelah kanan
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
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // Menu Login dan Register hanya ditampilkan jika belum login
            if (profileController.role.value == '')
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Login'),
                onTap: () {
                  Navigator.pop(context); // Menutup drawer
                  Get.offAll(LoginPageView()); // Navigasi ke halaman Login
                },
              ),
            if (profileController.role.value == '')
              ListTile(
                leading: const Icon(Icons.app_registration),
                title: const Text('Register'),
                onTap: () {
                  Navigator.pop(context); // Menutup drawer
                  Get.offAll(RegisterPageView()); // Navigasi ke halaman Register
                },
              ),
            // Tombol Logout hanya ditampilkan jika sudah login
            if (profileController.role.value != '')
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context); // Menutup drawer
                  profileController.logout();
                },
              ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage("https://via.placeholder.com/150"),
            ),
            const SizedBox(height: 16),
            Text(
              profileController.userName.value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              profileController.userEmail.value,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            // Tombol Admin Dashboard hanya ditampilkan jika role admin
            if (profileController.role.value == 'admin')
              ElevatedButton.icon(
                onPressed: profileController.goToAdminDashboard,
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text('Admin Dashboard'),
              ),
            const SizedBox(height: 16),
            // Tombol Logout
            if (profileController.role.value != '')
              ElevatedButton.icon(
                onPressed: profileController.logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 40),
                ),
              ),
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

