import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/admin/page/1_dashboard/controllers/dashboard_page_controller.dart';

class DashboardPageView extends StatelessWidget {
  const DashboardPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.put(DashboardController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
              100), // Mengatur tinggi AppBar sesuai yang diinginkan
          child: AppBar(
            centerTitle: true,
            title: const Text(
              'Admin Dashboard',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blueAccent,
            bottom: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(icon: Icon(Icons.add), text: 'Add Item'),
                Tab(icon: Icon(Icons.list), text: 'List Items'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Tab Add Item
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.white,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add New Item',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: dashboardController.nameController,
                          decoration: const InputDecoration(
                            labelText: 'Item Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: dashboardController.descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.description),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: dashboardController.hargaController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: double
                                .infinity, // Membuat tombol selebar kontainer
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    16), // Memberi ruang di sisi kiri dan kanan
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Mengurangi radius untuk sudut lebih sedikit membulat
                                ),
                              ),
                              onPressed: () {
                                // Validasi inputan sebelum menambahkan item
                                if (dashboardController
                                        .nameController.text.isEmpty ||
                                    dashboardController
                                        .descriptionController.text.isEmpty ||
                                    dashboardController
                                        .hargaController.text.isEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    'Please fill in all fields',
                                    backgroundColor: Colors.redAccent,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }
                                dashboardController.addItem();
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Add Item',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Tab List Items
            Obx(() {
              if (dashboardController.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.list_alt,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "No items found. Add new items to start.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: dashboardController.items.length,
                itemBuilder: (context, index) {
                  final item = dashboardController.items[index];
                  return Column(
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            '${item.description} - Rp ${item.harga}',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  dashboardController.showEditDialog(item);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  dashboardController.deleteItem(item.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                          color: Colors.grey.shade300), // Divider antar item
                    ],
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
