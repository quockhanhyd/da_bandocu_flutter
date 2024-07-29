import 'package:flutter/material.dart';
import 'package:shop/service/admin/order_service.dart';

class OrderDetailScreen extends StatefulWidget {
  final Map<Object, dynamic> order;

  OrderDetailScreen({super.key, required this.order});

  @override
  _OrderDetailScreen createState() => _OrderDetailScreen();
}

class _OrderDetailScreen extends State<OrderDetailScreen> {
  late Future<Map<Object, dynamic>> _orderDetails;
  late double totalAmount = 0.0;
  // Điều kiện hiển thị các nút "Hủy" và "Chấp nhận"
  late bool canCancel = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      canCancel =  widget.order['status'] >= 1 && widget.order['status'] <= 3;
      _orderDetails =
          OrderAdminService().getOrderDetails(widget.order['orderID']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng - ${widget.order['orderCode']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<Map<Object, dynamic>>(
          future: _orderDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('Không có chi tiết đơn hàng.'));
            } else {

              final data = snapshot.data!;
              final order = data['order'];
              final orderDetails = data['orderDetail'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderSummary(order),
                  SizedBox(height: 20),
                  Expanded(child: _buildOrderDetails(orderDetails)),
                  _buildActionButtons(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildOrderSummary(Map<String, dynamic> order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin đơn hàng',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text('Mã đơn hàng: ${order['orderCode']}'),
        Text('Tổng giá: ${order['totalPrice']} VND'),
        Text('Địa chỉ: ${order['address'] ?? 'Không có thông tin'}'),
        Text('Ghi chú: ${order['note'] ?? 'Không có'}'),
        Text('Trạng thái: ${_getStatusText(order['status'])}'),
      ],
    );
  }

  Widget _buildOrderDetails(List<dynamic> orderDetails) {
    // Tính tổng tiền của các sản phẩm
    // Khởi tạo totalAmount là 0
    // Tính tổng tiền của các sản phẩm
    orderDetails.forEach((item) {
      // Chuyển đổi giá và số lượng về kiểu double và int
      double price = (item['price'] as num).toDouble();
      int quantity = (item['quantity'] as num).toInt();
      totalAmount += price * quantity;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bảng chứa tiêu đề và danh sách sản phẩm
        Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: {
            0: FlexColumnWidth(4), // Tên sản phẩm
            1: FlexColumnWidth(2), // Số lượng
            2: FlexColumnWidth(2), // Đơn giá
            3: FlexColumnWidth(2), // Thành tiền
          },
          children: [
            // Tiêu đề
            TableRow(
              decoration: BoxDecoration(
                color: Colors.grey[200], // Màu nền cho tiêu đề
              ),
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tên sản phẩm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Số lượng',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Đơn giá',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Thành tiền',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            // Danh sách sản phẩm
            ...orderDetails.map((detail) {
              return TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        detail['productName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${detail['quantity']}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${detail['price']} VND',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${detail['price'] * detail['quantity']} VND',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
        // Tổng tiền
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Tổng tiền: ${totalAmount} VND',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(canCancel)
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Màu nền của nút Hủy bỏ
                ),
                onPressed: () {
                  // Xử lý sự kiện Hủy bỏ
                  final param = {
                    "orderId": widget.order['orderId'],
                    "accept": false
                  };
                  Navigator.pop(context, param);
                },
                child: Text('Hủy bỏ'),
              ),
            ),
          SizedBox(width: 10),
          if(canCancel)// Khoảng cách giữa hai nút
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Màu nền của nút Duyệt
                ),
                onPressed: () {
                  // Xử lý sự kiện Duyệt
                  final param = {
                    "orderId": widget.order['orderId'],
                    "accept": true
                  };
                  Navigator.pop(context, param);
                  // _approveOrder(widget.order['orderID']);
                },
                child: Text('Duyệt'),
              ),
            ),
        ],
      ),
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Chờ xác nhận';
      case 2:
        return 'Chờ lấy hàng';
      case 3:
        return 'Đang giao hàng';
      case 4:
        return 'Hoàn thành';
      case 5:
        return 'Hủy';
      default:
        return 'Không xác định';
    }
  }
}
