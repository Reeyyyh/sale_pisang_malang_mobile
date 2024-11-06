
import 'package:get/get.dart';

class FavoriteController extends GetxController {
  var favorites = <FavoriteItemModel>[].obs;

  @override
  void onInit() {
    fetchFavorites();
    super.onInit();
  }

  void fetchFavorites() {
    // Simulasi pengambilan data dari database
    // Ganti dengan pengambilan data sebenarnya
    favorites.value = [
      FavoriteItemModel(id: '1', name: 'Pisang Raja', price: '20.000'),
      FavoriteItemModel(id: '2', name: 'Pisang Ambon', price: '25.000'),
    ];
  }
}

class FavoriteItemModel {
  final String id;
  final String name;
  final String price;

  FavoriteItemModel({required this.id, required this.name, required this.price});
}
