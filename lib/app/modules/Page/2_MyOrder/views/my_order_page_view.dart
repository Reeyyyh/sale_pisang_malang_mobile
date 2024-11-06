import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/Page/2_MyOrder/controllers/my_order_page_controller.dart';


class MyOrderPageView extends StatelessWidget {
  const MyOrderPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final MyOrderController orderController = Get.put(MyOrderController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: Obx(() {
        if (orderController.orders.isEmpty) {
          return const Center(child: Text('No Orders Yet.'));
        }

        return ListView.builder(
          itemCount: orderController.orders.length,
          itemBuilder: (context, index) {
            final order = orderController.orders[index];
            return ListTile(
              title: Text(order.name),
              subtitle: Text('Price: ${order.price}\nStatus: ${order.status}'),
            );
          },
        );
      }),
    );
  }
}
