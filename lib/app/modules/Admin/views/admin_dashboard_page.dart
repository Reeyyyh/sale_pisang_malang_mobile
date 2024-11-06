import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/Page/4_Profile/views/profile_page_view.dart';
import 'package:sale_pisang_malang/app/modules/admin/controllers/admin_dashboard_controller.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Menginisialisasi AdminDashboardController
    final AdminDashboardController adminController = Get.put(AdminDashboardController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Logika untuk logout
              Get.offAll(() => const ProfilePageView());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (adminController.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: adminController.nameController,
                      decoration: const InputDecoration(labelText: 'Item Name'),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: adminController.descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: adminController.hargaController,
                      decoration: const InputDecoration(labelText: 'Price'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: adminController.addItem,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: adminController.items.length,
                itemBuilder: (context, index) {
                  final item = adminController.items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('${item.description} - ${item.harga}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        adminController.deleteItem(item.id);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
