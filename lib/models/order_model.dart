class OrderDetail {
  final int id;
  final int orderId;
  final String orderCode;
  final int productId;
  final String productName;
  final int quantity;
  final int price;
  final int totalPrice;

  OrderDetail({
    required this.id,
    required this.orderId,
    required this.orderCode,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  // Constructor để tạo đối tượng OrderDetail từ JSON
  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      orderId: json['orderId'],
      orderCode: json['orderCode'],
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      price: json['price'],
      totalPrice: json['totalPrice'],
    );
  }
}

class Order {
  final int orderId;
  final String orderCode;
  final int userId;
  final int merchanId;
  final int totalPrice;
  final String address;
  final int provinceId;
  final int districtId;
  final int wardId;
  final bool isDefault;
  final String? note;
  final int status;

  Order({
    required this.orderId,
    required this.orderCode,
    required this.userId,
    required this.merchanId,
    required this.totalPrice,
    required this.address,
    required this.provinceId,
    required this.districtId,
    required this.wardId,
    required this.isDefault,
    this.note,
    required this.status,
  });
}
