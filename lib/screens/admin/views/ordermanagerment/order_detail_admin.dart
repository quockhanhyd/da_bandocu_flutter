import 'package:flutter/material.dart';
import 'package:shop/models/order_model.dart';
import 'package:shop/service/admin/order_service.dart';

class OrderDetailScreen extends StatefulWidget {
  final Map<Object, dynamic> order;

  OrderDetailScreen({super.key, required this.order});

  @override
  _OrderDetailScreen createState() => _OrderDetailScreen();
}

class _OrderDetailScreen extends State<OrderDetailScreen> {
  late Future<List<OrderDetail>> _orderDetails;

  @override
  void initState() {
    super.initState();
    _orderDetails = OrderAdminService().getOrderDetails(widget.order['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng - ${widget.order['orderCode']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(),
            SizedBox(height: 20),
            Expanded(child: _buildOrderDetails()),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Thông tin đơn hàng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('Mã đơn hàng: ${widget.order['orderCode']}'),
        Text('Tổng giá: ${widget.order['totalPrice']} VND'),
        Text('Địa chỉ: ${widget.order['address']}'),
        Text('Ghi chú: ${widget.order['note'] ?? 'Không có'}'),
        Text('Trạng thái: ${_getStatusText(widget.order['status'])}'),
      ],
    );
  }

  Widget _buildOrderDetails() {
    return FutureBuilder<List<OrderDetail>>(
      future: _orderDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có chi tiết đơn hàng.'));
        } else {
          final orderDetails = snapshot.data!;
          return ListView.builder(
            itemCount: orderDetails.length,
            itemBuilder: (context, index) {
              final detail = orderDetails[index];
              return Card(
                child: ListTile(
                  title: Text(detail.productName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Số lượng: ${detail.quantity}'),
                      Text('Đơn giá: ${detail.price} VND'),
                      Text('Thành tiền: ${detail.totalPrice} VND'),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Chờ xác nhận';
      case 1:
        return 'Đang xử lý';
      case 2:
        return 'Đã hoàn tất';
      case 3:
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }
}
