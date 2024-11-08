// Model untuk item
import 'package:cloud_firestore/cloud_firestore.dart';

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
