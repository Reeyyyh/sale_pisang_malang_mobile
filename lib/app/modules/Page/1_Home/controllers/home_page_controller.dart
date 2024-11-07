import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sale_pisang_malang/app/models/items_model.dart';

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
}
