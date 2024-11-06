import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  var items = <ItemModel>[].obs;

  @override
  void onInit() {
    fetchItems();
    super.onInit();
  }

  void fetchItems() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('items').get();
    items.value = snapshot.docs.map((doc) => ItemModel.fromDocument(doc)).toList();
    update(); // Memastikan UI diperbarui setelah data dimuat
  }
}

class ItemModel {
  final String name;
  final String description;
  final String harga;

  ItemModel({required this.name, required this.description, required this.harga});

  factory ItemModel.fromDocument(DocumentSnapshot doc) {
    return ItemModel(
      name: doc['name'] ?? 'Tidak ada nama',
      description: doc['description'] ?? 'Tidak ada deskripsi',
      harga: doc['harga'] ?? '0',
    );
  }
}
