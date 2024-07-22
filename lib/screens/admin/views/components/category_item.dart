import 'package:flutter/material.dart';

import '../../../../route/route_constants.dart';

class CategoryItem extends StatelessWidget {
  final String categoryName;
  final int productCount;

  const CategoryItem({
    required this.categoryName,
    required this.productCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(categoryName),
        subtitle: Text('Số lượng sản phẩm: $productCount'),
        onTap: () {
          Navigator.pushNamed(
            context,
            categoryDetail,
            arguments: {
              'categoryName': categoryName,
              'productCount': productCount,
            },
          );
        },
      ),
    );
  }
}
