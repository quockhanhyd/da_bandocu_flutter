import 'package:flutter/material.dart';
import '../../../service/admin/category_service.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final CategoryService categoryService = CategoryService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm danh mục mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Tên danh mục'),
            ),
            SizedBox(height: 20), // Khoảng cách giữa các trường
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Mô tả'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final String name = nameController.text;
                final String description = descriptionController.text;
                try {
                  final data = {
                    "categoryID": 0,
                    "categoryName": name,
                    "description": description
                  };
                  final success = await categoryService.insertOrUpdateCategoryAsync(data);
                  if (success) {
                    Navigator.pop(context, 'add');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Thêm mới thất bại!')),
                    );
                  }
                } catch (e) {
                  print('Failed to add category: $e');
                }
              },
              child: Text('Thêm danh mục'),
            ),
          ],
        ),
      ),
    );
  }
}
