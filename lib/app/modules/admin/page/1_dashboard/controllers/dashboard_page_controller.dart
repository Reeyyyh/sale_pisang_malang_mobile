import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sale_pisang_malang/app/models/items_model.dart';

class DashboardController extends GetxController {
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
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('items').get();
    items.value =
        snapshot.docs.map((doc) => ItemModel.fromDocument(doc)).toList();
  }

  Future<void> addItem() async {
    if (nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        hargaController.text.isNotEmpty) {
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('items').add({
        'name': nameController.text,
        'description': descriptionController.text,
        'harga': hargaController.text,
      });
      await docRef.update({'id': docRef.id});
      nameController.clear();
      descriptionController.clear();
      hargaController.clear();
      fetchItems();
      Get.snackbar('Item Added', '${nameController.text} has been added.',
          snackPosition: SnackPosition.TOP);
    } else {
      Get.snackbar('Error', 'Please fill all fields',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> deleteItem(String id) async {
    await FirebaseFirestore.instance.collection('items').doc(id).delete();
    fetchItems();
    Get.snackbar('Item Deleted', 'Item has been deleted.',
        snackPosition: SnackPosition.TOP);
  }

  void showEditDialog(ItemModel item) {
    // Initialize fields with current values
    nameController.text = item.name;
    descriptionController.text = item.description;
    hargaController.text = item.harga;

    Get.defaultDialog(
      title: 'Edit Item',
      titleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
      contentPadding: const EdgeInsets.all(16),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update the details below:',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                labelStyle: const TextStyle(fontSize: 14, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: const TextStyle(fontSize: 14, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: hargaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                labelStyle: const TextStyle(fontSize: 14, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
      textConfirm: 'Save',
      confirmTextColor: Colors.white,
      textCancel: 'Cancel',
      cancelTextColor: Colors.blueAccent,
      buttonColor: Colors.blueAccent,
      radius: 10,
      onConfirm: () {
        updateItem(item.id);
        nameController.clear();
        descriptionController.clear();
        hargaController.clear();
        Get.back(); // Close dialog
      },
      onCancel: () {
        nameController.clear();
        descriptionController.clear();
        hargaController.clear();
        Get.back();
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
    Get.snackbar('Item Updated', 'Item has been updated.',
        snackPosition: SnackPosition.TOP);
  }
}
