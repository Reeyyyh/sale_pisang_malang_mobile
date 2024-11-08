import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/Page/4_Profile/controllers/profile_page_controller.dart';
import 'package:sale_pisang_malang/app/modules/auth/views/login_page_view.dart';
import 'package:sale_pisang_malang/app/modules/auth/views/signup_page_view.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Stack(
          children: [
            // Shadow layer
            Positioned.fill(
              child: Transform.scale(
                scale: 1.10, // Slightly larger for shadow effect
                child: ClipPath(
                  clipper: AppBarClipper(),
                  child: Container(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                  ),
                ),
              ),
            ),
            // Main AppBar layer
            ClipPath(
              clipper: AppBarClipper(),
              child: AppBar(
                title: const Text(
                  'Profile',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                centerTitle: true,
                backgroundColor: Colors.blueAccent,
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
                      height: 120,
                      color: Colors.deepPurple,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: const Text(
                        'Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Obx(() {
                    if (profileController.role.value.isEmpty) {
                      return Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.login, size: 30),
                            title: const Text('Login'),
                            onTap: () {
                              Navigator.pop(context);
                              Get.to(() => LoginPageView())?.then((_) async {
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                Get.offAll(() => LoginPageView());
                              });
                            },
                          ),
                          ListTile(
                            leading:
                                const Icon(Icons.app_registration, size: 30),
                            title: const Text('Sign Up'),
                            onTap: () {
                              Navigator.pop(context);
                              Get.to(() => SignUpPageView())?.then((_) async {
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                Get.offAll(() => SignUpPageView());
                              });
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
            // Footer yang diletakkan di bagian bawah Drawer
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF2A2A2A), // Background lebih gelap
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.instagram,
                          color: Color(0xFFE4405F), // Warna khas Instagram
                          size: 30,
                        ),
                        onPressed: () => {},
                      ),
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.shopify,
                          color: Color(0xFFFF8C42), // Warna oranye yang serasi
                          size: 30,
                        ),
                        onPressed: () => {},
                      ),
                    ],
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
                radius: 60,
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
            const SizedBox(height: 24),

            // Gunakan Expanded atau Flexible di sini untuk memastikan tampilan
            Obx(() {
              if (profileController.role.value == 'admin') {
                return Card(
                  elevation: 5,
                  child: ListTile(
                    leading: const Icon(Icons.admin_panel_settings,
                        color: Colors.blueAccent),
                    title: const Text('Admin Dashboard'),
                    onTap: profileController.goToAdminDashboard,
                  ),
                );
              }
              return Container();
            }),
            const SizedBox(height: 16),
            const Divider(),

            Card(
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {},
              ),
            ),
            Card(
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 24),

            // Gunakan Expanded atau Flexible di sini
            Obx(() {
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
            }),
          ],
        ),
      ),
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
