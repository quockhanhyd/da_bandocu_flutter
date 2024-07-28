class CartModel {
  final int? cartId, productId, quantity, price, total;
  final String? productName, imageUrl;

  CartModel(
      {required this.cartId,
      this.productId,
      this.quantity,
      this.price,
      this.total,
      this.productName,
      this.imageUrl});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json['cartId'],
      productId: json['productId'],
      quantity: json['quantity'],
      price: json['price'],
      total: json['total'],
      productName: json['productName'],
      imageUrl: json['imageUrl'],
    );
  }
}
