import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  var items = <ItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems(); // Start listening to Firestore changes
  }

  // Menggunakan Stream untuk mendengarkan perubahan item
  void fetchItems() {
    FirebaseFirestore.instance
        .collection('items')
        .snapshots()
        .listen((snapshot) {
      items.value = snapshot.docs
          .map((doc) => ItemModel.fromDocument(doc))
          .toList();
    });
  }

  // Fungsi untuk menambah item ke Firestore
  Future<void> addItem(ItemModel item) async {
    await FirebaseFirestore.instance.collection('items').add({
      'name': item.name,
      'description': item.description,
      'harga': item.harga,
    });
  }

  // Fungsi untuk menghapus item dari Firestore
  Future<void> deleteItem(String itemId) async {
    await FirebaseFirestore.instance.collection('items').doc(itemId).delete();
  }
}

class ItemModel {
  final String id;
  final String name;
  final String description;
  final String harga;

  ItemModel({required this.id, required this.name, required this.description, required this.harga});

  factory ItemModel.fromDocument(DocumentSnapshot doc) {
    return ItemModel(
      id: doc.id, // ID dokumen dari Firestore
      name: doc['name'] ?? 'Tidak ada nama',
      description: doc['description'] ?? 'Tidak ada deskripsi',
      harga: doc['harga'] ?? '0',
    );
  }
}
