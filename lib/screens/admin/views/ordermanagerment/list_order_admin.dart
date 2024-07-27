import 'package:flutter/material.dart';
import 'package:shop/screens/admin/views/ordermanagerment/order_detail_admin.dart';
import 'package:shop/service/admin/order_service.dart';

class OrderListScreen extends StatefulWidget {
  final Map<Object, dynamic> ordersName; // Đổi Object thành String

  OrderListScreen({super.key, required this.ordersName});

  @override
  _OrderListScreen createState() => _OrderListScreen();
}

class _OrderListScreen extends State<OrderListScreen> {
  late Future<List<Map<String, dynamic>>> _orders;

  @override
  void initState() {
    super.initState();
    _orders = OrderAdminService().GetByStatus(widget.ordersName['status']);
  }

  void _handleOrderTap(Map<Object, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailScreen(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách đơn hàng - ${widget.ordersName['statusName']}'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có đơn hàng nào.'));
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                // Điều kiện hiển thị các nút "Hủy" và "Chấp nhận"
                bool canCancel = order['status'] == 'pending';
                bool canApprove = order['status'] == 'pending';

                return ListTile(
                  title: Text('Đơn hàng ${order['id']}'),
                  onTap: () => _handleOrderTap(order),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (canCancel) // Hiển thị nút Hủy nếu có thể
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red),
                          onPressed: () {
                            // Xử lý hành động "Hủy" ở đây
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Đơn hàng ${order['id']} đã được hủy'),
                              ),
                            );
                          },
                        ),
                      if (canApprove) // Hiển thị nút Chấp nhận nếu có thể
                        SizedBox(width: 8),
                      if (canApprove) // Hiển thị nút Chấp nhận nếu có thể
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            // Xử lý hành động "Chấp nhận" ở đây
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Đơn hàng ${order['id']} đã được chấp nhận'),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
