import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productImage;
  final String productCategory;

  const ProductItem({
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Image.network(
          productImage,
          fit: BoxFit.cover,
          width: 50.0,
          height: 50.0,
        ),
        title: Text(productName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(productPrice),
            Text('Danh mục: $productCategory'),
          ],
        ),
      ),
    );
  }
}
