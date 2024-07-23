import 'package:flutter/material.dart';
import '../../../route/route_constants.dart';
import 'components/category_item.dart';
import '../../../service/admin/category_service.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  late Future<List<Map<Object, dynamic>>> _categories;
  final param = {"currentPage": 1, "pageSize": 20, "textSearch": ""};

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      _categories = CategoryService().getCategories(param);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách danh mục'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result =
                  await Navigator.pushNamed(context, addCategoryRoute);
              if (result == 'add') {
                _loadCategories();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<Object, dynamic>>>(
        future: _categories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories found'));
          } else {
            final categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryItem(
                  categoryID: category['categoryID'] ?? 0,
                  categoryName: category['categoryName'] ?? '',
                  productCount: category['productCount'] ?? 0,
                  description: category['description'] ?? '',
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      categoryDetail, // Đảm bảo đúng tên tuyến đường
                      arguments: category,
                    );
                    if (result == 'updated' || result == 'deleted') {
                      _loadCategories(); // Reload categories
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
