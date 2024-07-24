import 'package:flutter/material.dart';
import 'package:shop/models/category_model.dart';
import '../../../service/admin/category_service.dart';

class CategoryDetailScreen extends StatelessWidget {
  final CategoryModel2 category;

  // Nhận dữ liệu từ Navigator
  CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: category.categoryName);
    final TextEditingController descriptionController = TextEditingController(text: category.description);
    final CategoryService categoryService = CategoryService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết danh mục'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final categoryId = category.categoryID;

              try {
                final res = await categoryService.deleteCategory(categoryId);
                if(res){
                  Navigator.pop(context, 'deleted'); // Trả về giá trị 'deleted'
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Xóa thất bại!')),
                  );
                }
              } catch (e) {
                print('Failed to delete category: $e');
              }
            },
          ),
        ],
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

                final updatedData = {
                  "categoryID": category.categoryID,
                  "categoryName": name,
                  "description": description,
                };

                try {
                  final res = await categoryService.insertOrUpdateCategoryAsync(updatedData);
                  if(res){
                    Navigator.pop(context, 'updated');
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Xóa thất bại!')),
                    );
                  }
                } catch (e) {
                  print('Failed to update category: $e');
                }
              },
              child: Text('Cập nhật danh mục'),
            ),
          ],
        ),
      ),
    );
  }
}
