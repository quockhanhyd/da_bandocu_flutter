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
    _loadDataOrders();
  }

  void _loadDataOrders() {
    setState(() {
      _orders = OrderAdminService().GetByStatus(widget.ordersName['status']);
    });
  }

  void _handleOrderTap(Map<Object, dynamic> order) async {
    final param = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailScreen(order: order),
      ),
    );
    if (param != null) {
      // Xử lý kết quả trả về từ OrderDetailScreen
      param['orderId'] = order['orderID'];
      UpdateStatusAsync(param);
    }
  }

  void UpdateStatusAsync(Object param) async {
    // Ví dụ: gọi API để cập nhật trạng thái đơn hàng
    final res = await OrderAdminService().updateStatusAsync(param);
    if (res) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật thành công!')),
      );
      _loadDataOrders();
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật thất bại!')),
      );
      _loadDataOrders();
      Navigator.pop(context, false);
    }
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
                bool canCancel = order['status'] >= 1 && order['status'] <= 3;
                bool canApprove = order['status'] >= 1 && order['status'] <= 3;

                return ListTile(
                  title: Text('Đơn hàng ${order['orderCode']}'),
                  onTap: () => _handleOrderTap(order),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (canCancel) // Hiển thị nút Hủy nếu có thể
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red),
                          onPressed: () {
                            final pram = {
                              "orderId": order['orderID'],
                              "accept": false
                            };
                            UpdateStatusAsync(pram);
                          },
                        ),
                      if (canApprove) // Hiển thị nút Chấp nhận nếu có thể
                        SizedBox(width: 8),
                      if (canApprove) // Hiển thị nút Chấp nhận nếu có thể
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            final pram = {
                              "orderId": order['orderID'],
                              "accept": true
                            };
                            UpdateStatusAsync(pram);
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
