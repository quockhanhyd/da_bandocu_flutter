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
  final int productPriceSale;
  final List<String> productImages; // List of image URLs
  final String productCategory;
  final int percentSale;
  final String description;
  final VoidCallback onTap;

  const ProductItem({
    required this.productName,
    required this.productPrice,
    required this.productImages,
    required this.productCategory,
    required this.percentSale,
    required this.description,
    required this.productPriceSale,
    required this.onTap,
  });

  double _calculateDiscountedPrice() {
    final double price = double.tryParse(productPrice.toString()) ?? 0.0;
    final double percentSales = double.tryParse(percentSale.toString()) ?? 0.0;
    return price - (percentSales / 100 * price);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.network(
                        productImages[index].trim(),
                        fit: BoxFit.cover,
                        width: 100.0,
                        height: 100.0,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('Error loading image: $error');
                          return Icon(Icons.error, color: Colors.red);
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tên sản phẩm: $productName',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text('Giá bán: $productPrice VND'),
                    Text('Giảm giá: $percentSale%'),
                    Text(
                      'Giá sau khi giảm: $productPriceSale VND',
                    ),
                    SizedBox(height: 4.0),
                    Text('Danh mục: $productCategory'),
                    SizedBox(height: 8.0),
                    Text(
                      'Mô tả: $description',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
