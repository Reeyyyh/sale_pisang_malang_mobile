import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      fetchItems(); // Refresh the list after adding
      Get.snackbar('Item Added', '${nameController.text} has been added.');
    } else {
      Get.snackbar('Error', 'Please fill all fields');
    }
  }

  Future<void> deleteItem(String id) async {
    await FirebaseFirestore.instance.collection('items').doc(id).delete();
    fetchItems(); // Refresh the list after deleting
    Get.snackbar('Item Deleted', 'Item has been deleted.');
  }
}

// Model untuk item
class ItemModel {
  final String id;
  final String name;
  final String description;
  final String harga;

  ItemModel({required this.id, required this.name, required this.description, required this.harga});

  factory ItemModel.fromDocument(DocumentSnapshot doc) {
    return ItemModel(
      id: doc.id,
      name: doc['name'] ?? 'Tidak ada nama',
      description: doc['description'] ?? 'Tidak ada deskripsi',
      harga: doc['harga'] ?? '0',
    );
  }
}
