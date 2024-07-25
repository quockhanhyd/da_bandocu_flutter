import 'package:flutter/material.dart';

class OrderListScreen extends StatelessWidget {
  final String statusName;

  const OrderListScreen({super.key, required this.statusName});

  @override
  Widget build(BuildContext context) {
    // Giả sử đây là danh sách đơn hàng cho trạng thái cụ thể
    final List<String> orders = [
      'Đơn hàng 1',
      'Đơn hàng 2',
      'Đơn hàng 3',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách đơn hàng - $statusName'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(orders[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.red),
                  onPressed: () {
                    // Xử lý hành động "Hủy" ở đây
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đơn hàng ${orders[index]} đã được hủy'),
                      ),
                    );
                  },
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    // Xử lý hành động "Chấp nhận" ở đây
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đơn hàng ${orders[index]} đã được chấp nhận'),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
