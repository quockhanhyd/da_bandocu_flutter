import 'package:flutter/material.dart';
import 'package:shop/service/admin/product_service.dart';
import '../../../models/product_model.dart';
import '../../../route/route_constants.dart';
import 'components/ProductItem.dart';

class ManagerProduct extends StatefulWidget {
  const ManagerProduct({super.key});

  @override
  _ManagerProductState createState() => _ManagerProductState();
}

class _ManagerProductState extends State<ManagerProduct> {
  late Future<List<ProductModel2>> _products;
  final param = {"currentPage": 1, "pageSize": 20, "textSearch": ""};

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _products = ProductService().getProducts(param);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách sản phẩm'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result =
                  await Navigator.pushNamed(context, managerAddProductRoute);
              if (result == 'add') {
                _loadProducts();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ProductModel2>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductItem(
                  productName: product.productName ?? '',
                  productPrice: product.price ?? 0,
                  productImage: product.imageUrl ?? '',
                  productCategory: product.categoryName ?? '',
                  percentSale: product.percentSale ?? 0,
                  description: product.description ?? '',
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      productDetail, // Đảm bảo đúng tên tuyến đường
                      arguments: product,
                    );
                    if (result == 'updated' || result == 'deleted') {
                      _loadProducts(); // Reload categories
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

