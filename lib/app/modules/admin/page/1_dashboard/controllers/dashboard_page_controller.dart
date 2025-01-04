import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sale_pisang_malang/app/models/items_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class DashboardController extends GetxController {
  var items = <ItemModel>[].obs;
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var hargaController = TextEditingController();

  var selectedImage = Rx<File?>(null);

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    fetchItems();
    super.onInit();
  }

  Future<String?> uploadToCloudinary(File imageFile) async {
    const cloudName = 'dsdqizkji';
    const uploadPreset = 'salepisang';

    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return jsonDecode(responseData)['secure_url'];
    } else {
      print('Cloudinary upload failed: ${response.statusCode}');
      return null;
    }
  }

  void fetchItems() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('items').get();
    items.value =
        snapshot.docs.map((doc) => ItemModel.fromDocument(doc)).toList();
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        print('Image picked: ${pickedFile.path}');
      } else {
        print('No image selected');
        Get.snackbar(
          'No Image selected',
          'select image to upload',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

Future<void> addItem(File? imageFile) async {
  if (nameController.text.isNotEmpty &&
      descriptionController.text.isNotEmpty &&
      hargaController.text.isNotEmpty) {
    String? imgUrl;

    // Upload ke Cloudinary jika ada gambar
    if (imageFile != null) {
      imgUrl = await uploadToCloudinary(imageFile);
    }

    // Placeholder jika tidak ada gambar
    imgUrl ??= 'https://via.placeholder.com/150?text=No+Image';

    // Tambahkan item ke Firestore
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('items').add({
      'name': nameController.text,
      'description': descriptionController.text,
      'harga': hargaController.text,
      'imgUrl': imgUrl,
    });

    // Update ID dokumen
    await docRef.update({'id': docRef.id});

    // Reset semua field input
    nameController.clear();
    descriptionController.clear();
    hargaController.clear();
    selectedImage.value = null; // Reset gambar yang dipilih
    fetchItems();

    // Snackbar sukses
    Get.snackbar(
      'Item Added',
      '${nameController.text} has been added.',
      snackPosition: SnackPosition.TOP,
    );
  } else {
    // Snackbar error
    Get.snackbar(
      'Error',
      'Please fill all fields',
      snackPosition: SnackPosition.TOP,
    );
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
        color: Color.fromRGBO(255, 170, 0, 1),
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
                  borderSide: BorderSide(color: Color.fromRGBO(255, 170, 0, 1), width: 2),
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
                  borderSide: BorderSide(color: Color.fromRGBO(255, 170, 0, 1), width: 2),
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
                  borderSide: BorderSide(color: Color.fromRGBO(255, 170, 0, 1), width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
      textConfirm: 'Save',
      confirmTextColor: Colors.white,
      textCancel: 'Cancel',
      cancelTextColor: const Color.fromRGBO(255, 170, 0, 1),
      buttonColor: const Color.fromRGBO(255, 170, 0, 1),
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
