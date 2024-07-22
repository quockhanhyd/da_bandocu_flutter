import 'package:flutter/material.dart';
import '../../../route/route_constants.dart';
import 'components/category_item.dart';
class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách danh mục'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, addProductRoute);
            },
          ),
        ],
      ),
      body: ListView(
        children: const [
          CategoryItem(
            categoryName: 'Danh mục 1',
            productCount: 10,
          ),
          CategoryItem(
            categoryName: 'Danh mục 2',
            productCount: 20,
          ),
          CategoryItem(
            categoryName: 'Danh mục 3',
            productCount: 30,
          ),
          // Thêm nhiều danh mục hơn ở đây
        ],
      ),
    );
  }
}
