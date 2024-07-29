import 'package:flutter/material.dart';
import 'package:shop/screens/admin/views/ordermanagerment/list_order_admin.dart';
import 'package:shop/service/admin/order_service.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final param = {"merchanID": 1};

  late Future<List<Map<Object, dynamic>>> _dataOrders;

  @override
  void initState() {
    super.initState();
    _loadOrdersMange();
  }

  void _loadOrdersMange() {
    setState(() {
      _dataOrders = OrderAdminService().getOrdersByMerchanIDAsync(param);
    });
  }

  void _navigateToOrderList(Map<Object, dynamic> orders) async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderListScreen(ordersName: orders),
      ),
    );
    if (res) {
      _loadOrdersMange();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý đơn hàng'),
      ),
      body: FutureBuilder<List<Map<Object, dynamic>>>(
        future: _dataOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có dữ liệu'));
          }

          final orderStatuses = snapshot.data!;

          return ListView.builder(
            itemCount: orderStatuses.length,
            itemBuilder: (context, index) {
              final orderStatus = orderStatuses[index];
              return ListTile(
                title: Text(orderStatus['statusName'] ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      child: Text(
                        '${orderStatus['totalCount'] ?? 0}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
                onTap: () => _navigateToOrderList(orderStatus),
              );
            },
          );
        },
      ),
    );
  }
}
