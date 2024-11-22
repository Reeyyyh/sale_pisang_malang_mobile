import 'package:get/get.dart';

class MyOrderController extends GetxController {
  var orders = <OrderModel>[].obs;

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  void fetchOrders() {
    // Simulasi pengambilan data dari database
    // Ganti dengan pengambilan data sebenarnya
    orders.value = [
      OrderModel(id: '1', name: 'Pisang Coklat', price: '20.000', status: 'Pending'),
      OrderModel(id: '2', name: 'Pisang Keju', price: '25.000', status: 'Completed'),
      OrderModel(id: '3', name: 'kripik pisang', price: '30.000', status: 'Cancelled'),
    ];
  }
}

class OrderModel {
  final String id;
  final String name;
  final String price;
  final String status;

  OrderModel({required this.id, required this.name, required this.price, required this.status});
}
