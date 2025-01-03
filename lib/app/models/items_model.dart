// Model untuk item
import 'package:cloud_firestore/cloud_firestore.dart';

// Model untuk item model admin menambahkan barang
class ItemModel {
  final String id;
  final String name;
  final String description;
  final String harga;

  ItemModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.harga});

  factory ItemModel.fromDocument(DocumentSnapshot doc) {
    return ItemModel(
      id: doc.id,
      name: doc['name'] ?? 'Tidak ada nama',
      description: doc['description'] ?? 'Tidak ada deskripsi',
      harga: doc['harga'] ?? '0',
    );
  }
}

// Model untuk item favorit
class FavoriteItem {
  final String id;
  final String name;
  final String price;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.price,
  });
}

// Model untuk order
class OrderModel {
  final String id;
  final String name;
  final String price;
  final String status;

  OrderModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.status});
}

// model untuk chat
class ChatMessage {
  final String message;
  final String sender;
  final DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.sender,
    required this.timestamp,
  });

  // Untuk mengubah data chat dari Firestore ke dalam bentuk objek
  factory ChatMessage.fromFirestore(Map<String, dynamic> firestoreData) {
    return ChatMessage(
      message: firestoreData['message'],
      sender: firestoreData['sender'],
      timestamp: (firestoreData['timestamp'] as Timestamp).toDate(),
    );
  }

  // Untuk mengubah objek menjadi format Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'message': message,
      'sender': sender,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}