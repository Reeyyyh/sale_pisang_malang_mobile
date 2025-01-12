// Model untuk item
import 'package:cloud_firestore/cloud_firestore.dart';

// Model untuk item model admin menambahkan barang
class ItemModel {
  final String id;
  final String name;
  final String description;
  final String harga;
  final String imgUrl;

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.harga,
    required this.imgUrl,
  });

  factory ItemModel.fromDocument(DocumentSnapshot doc) {
    return ItemModel(
      id: doc.id,
      name: doc['name'] ?? 'Tidak ada nama',
      description: doc['description'] ?? 'Tidak ada deskripsi',
      harga: doc['harga'] ?? '0',
      imgUrl: doc['imgUrl'] ?? '', // Nilai default kosong jika tidak ada URL
    );
  }
}

// Model untuk item favorit
class FavoriteItem {
  final String id;
  final String name;
  final String price;
  final String imgUrl;
  final String description;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imgUrl,
    required this.description,
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

// model untuk history
class HistoryModel {
  final String id;
  final String name;
  final String price;
  final Timestamp timestamp;

  HistoryModel({
    required this.id,
    required this.name,
    required this.price,
    required this.timestamp,
  });

  // Menambahkan fungsi untuk mengkonversi dari data Firestore
  factory HistoryModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return HistoryModel(
      id: doc.id,
      name: data['itemName'],
      price: data['itemPrice'],
      timestamp: data['timestamp'], // Pastikan timestamp disimpan di Firestore
    );
  }

  // Menambahkan fungsi untuk mengubah data ke dalam format untuk disimpan di Firestore
  Map<String, dynamic> toMap() {
    return {
      'itemName': name,
      'itemPrice': price,
      'timestamp': timestamp,
    };
  }
}
