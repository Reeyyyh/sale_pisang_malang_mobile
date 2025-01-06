import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Impor intl untuk format tanggal
import 'package:sale_pisang_malang/app/modules/admin/page/2_checkout/controllers/list_checkout_controller.dart';

class ListCheckoutPage extends StatelessWidget {
  const ListCheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menginisialisasi controller
    final ListCheckoutController controller = Get.put(ListCheckoutController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Checkout List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(
            255, 170, 0, 1), // Menambahkan warna background sesuai permintaan
        elevation: 4, // Menambahkan efek bayangan pada app bar
      ),
      body: Obx(() {
  // Jika masih memuat data
  if (controller.isLoading.value) {
    return const Center(child: CircularProgressIndicator());
  }

  // Jika data kosong
  if (controller.checkoutData.isEmpty) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined, // Ikon keranjang kosong
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No checkout data available.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Urutkan data berdasarkan timestamp (ascending)
  final sortedCheckoutData = controller.checkoutData.toList();
  sortedCheckoutData.sort((a, b) {
    final timestampA = a['timestamp']?.toDate();
    final timestampB = b['timestamp']?.toDate();
    if (timestampA == null || timestampB == null) return 0;
    return timestampA.compareTo(timestampB); // Ascending order
  });

  // Jika data tersedia
  return ListView.builder(
    itemCount: sortedCheckoutData.length,
    itemBuilder: (context, index) {
      final checkoutItem = sortedCheckoutData[index];
      final userName = checkoutItem['userName'];
      final orderDetails = checkoutItem['orderDetails'] as List;
      final timestamp = checkoutItem['timestamp']?.toDate();
      final formattedDate = timestamp != null
          ? DateFormat('yyyy-MM-dd HH:mm').format(timestamp)
          : 'No date available';

      return Dismissible(
        key: Key(checkoutItem['docId']), // Gunakan docId sebagai key
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          color: Colors.redAccent,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
        ),
        onDismissed: (direction) {
          controller
              .deleteCheckoutItem(checkoutItem['docId']); // Kirim docId
        },
        child: Card(
          margin: const EdgeInsets.all(12),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.shopping_cart,
                size: 30,
                color: Colors.green[600],
              ),
              trailing: const Icon(
                Icons.chevron_left,
                color: Colors.grey,
              ),
              title: Text(
                'Pembeli : $userName',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...orderDetails.map<Widget>((order) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                            // Menggunakan Expanded agar itemName tidak melebihi batas
                            child: Text(
                              '${order['itemName']} - ',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow
                                  .ellipsis, // Memotong teks yang terlalu panjang
                            ),
                          ),
                          Text(
                            '\$${order['itemPrice']}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Ordered on: $formattedDate',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          ),
        ),
      );
    },
  );
}),

    );
  }
}
