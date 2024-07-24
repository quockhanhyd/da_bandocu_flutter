import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';

HttpClient createHttpClient() {
  final httpClient = HttpClient();
  httpClient.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;
  return httpClient;
}

final ioClient = IOClient(createHttpClient());

class ProductItem extends StatelessWidget {
  final String productName;
  final int productPrice;
  final String productImage; // Đường dẫn tới ảnh cục bộ
  final String productCategory;
  final int percentSale;
  final String description;
  final VoidCallback onTap; // T

  const ProductItem({
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productCategory,
    required this.percentSale,
    required this.description,
    required this.onTap,
  });

  double _calculateDiscountedPrice() {
    final double price = double.tryParse(productPrice.toString()) ?? 0.0;
    final double percentSales =
        double.tryParse(percentSale.toString()) ?? 0.0;
    return price - (percentSales / 100 * price);
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
          leading: Image.network(
            productImage,
            fit: BoxFit.cover,
            width: 100.0,
            height: 100.0,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Error loading image: $error');
              return Icon(Icons.error, color: Colors.red);
            },
          ),
          title: Text('Tên sản phẩm: $productName'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Giá bán: $productPrice VND'),
              Text('Giam giá: $percentSale%'),
              Text('Giá sau khi giảm: ${(_calculateDiscountedPrice()).toStringAsFixed(2)} VND'),
              Text('Mô tả: $description'),
              Text('Danh mục: $productCategory'),
            ],
          ),
          onTap: onTap),
    );
  }
}
