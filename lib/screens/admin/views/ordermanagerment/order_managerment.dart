import 'package:flutter/material.dart';
import 'package:shop/screens/admin/views/ordermanagerment/list_order_admin.dart';


class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  _OrderManagementState createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagementScreen> {
  final List<Map<String, dynamic>> orderStatuses = [
    {'name': 'Chờ xác nhận', 'count': 1},
    {'name': 'Chờ lấy hàng', 'count': 230},
    {'name': 'Đã duyệt', 'count': 211},
    {'name': 'Đã hủy', 'count': 1},
  ];

  void _navigateToOrderList(String statusName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderListScreen(statusName: statusName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý đơn hàng'),
      ),
      body: ListView.builder(
        itemCount: orderStatuses.length,
        itemBuilder: (context, index) {
          final status = orderStatuses[index];
          return ListTile(
            title: Text(status['name']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 20,
                  child: Text(
                    '${status['count']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
            onTap: () => _navigateToOrderList(status['name']),
          );
        },
      ),
    );
  }
}
