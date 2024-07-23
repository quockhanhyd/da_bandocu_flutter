import 'package:flutter/material.dart';
import '../../../../route/route_constants.dart'; // Cập nhật đường dẫn chính xác

class CategoryItem extends StatelessWidget {
  final int categoryID;
  final String categoryName;
  final String description;
  final int productCount;
  final VoidCallback onTap; // Thêm onTap

  const CategoryItem({
    required this.categoryID,
    required this.categoryName,
    required this.description,
    required this.productCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
          title: Text(categoryName),
          subtitle: Text('Số lượng sản phẩm: $productCount'),
          onTap: onTap),
    );
  }
}
