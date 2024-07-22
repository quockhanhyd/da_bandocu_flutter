import 'package:flutter/material.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text(arguments['categoryName']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tên danh mục: ${arguments['categoryName']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Số lượng sản phẩm: ${arguments['productCount']}',
              style: TextStyle(fontSize: 16),
            ),
            // Thêm chi tiết khác về danh mục tại đây
          ],
        ),
      ),
    );
  }
}
