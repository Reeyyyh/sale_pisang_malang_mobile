import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/admin/controllers/admin_dashboard_controller.dart';
import 'package:sale_pisang_malang/app/modules/home/views/start_page_view.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Menginisialisasi AdminDashboardController
    final AdminDashboardController adminController =
        Get.put(AdminDashboardController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.offAll(() => const StartPageView());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (adminController.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form untuk menambahkan item
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: adminController.nameController,
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: adminController.descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: adminController.hargaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: adminController.addItem,
                        child: const Text('Add Item'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // List item yang telah ditambahkan
              Expanded(
                child: ListView.builder(
                  itemCount: adminController.items.length,
                  itemBuilder: (context, index) {
                    final item = adminController.items[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text('${item.description} - Rp ${item.harga}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                adminController.showEditDialog(item);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                adminController.deleteItem(item.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
