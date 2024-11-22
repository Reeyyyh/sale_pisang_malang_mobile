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
        centerTitle: true,
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.blueAccent, //
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (orderController.orders.isEmpty) {
            return const Center(
              child: Text(
                'No Orders Yet.',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: orderController.orders.length,
            itemBuilder: (context, index) {
              final order = orderController.orders[index];
              return Card(
                elevation: 4.0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    order.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price: ${order.price}',
                        style:
                            const TextStyle(color: Colors.green, fontSize: 16),
                      ),
                      Text(
                        'Status: ${order.status}',
                        style:
                            const TextStyle(color: Colors.orange, fontSize: 14),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey[600],
                  ),
                  onTap: () {
                    // Add your onTap functionality here (e.g., navigate to order details)
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
