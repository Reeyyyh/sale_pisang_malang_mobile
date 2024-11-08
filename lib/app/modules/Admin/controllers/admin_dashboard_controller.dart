import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sale_pisang_malang/app/models/items_model.dart';

class AdminDashboardController extends GetxController {
  var items = <ItemModel>[].obs;
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var hargaController = TextEditingController();

  @override
  void onInit() {
    fetchItems();
    super.onInit();
  }

  void fetchItems() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('items').get();
    items.value = snapshot.docs.map((doc) => ItemModel.fromDocument(doc)).toList();
  }

  Future<void> addItem() async {
    if (nameController.text.isNotEmpty && descriptionController.text.isNotEmpty && hargaController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('items').add({
        'name': nameController.text,
        'description': descriptionController.text,
        'harga': hargaController.text,
      });
      nameController.clear();
      descriptionController.clear();
      hargaController.clear();
      fetchItems();
      Get.snackbar('Item Added', '${nameController.text} has been added.', snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Please fill all fields', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteItem(String id) async {
    await FirebaseFirestore.instance.collection('items').doc(id).delete();
    fetchItems();
    Get.snackbar('Item Deleted', 'Item has been deleted.', snackPosition: SnackPosition.BOTTOM);
  }

  void showEditDialog(ItemModel item) {
    // Initialize fields with current values
    nameController.text = item.name;
    descriptionController.text = item.description;
    hargaController.text = item.harga;

    Get.defaultDialog(
      title: 'Edit Item',
      content: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Item Name'),
          ),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          TextFormField(
            controller: hargaController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Price'),
          ),
        ],
      ),
      textConfirm: 'Save',
      textCancel: 'Cancel',
      onConfirm: () {
        updateItem(item.id);
        Get.back(); // Close dialog
      },
    );
  }

  Future<void> updateItem(String id) async {
    await FirebaseFirestore.instance.collection('items').doc(id).update({
      'name': nameController.text,
      'description': descriptionController.text,
      'harga': hargaController.text,
    });
    fetchItems();
    Get.snackbar('Item Updated', 'Item has been updated.', snackPosition: SnackPosition.BOTTOM);
  }
}