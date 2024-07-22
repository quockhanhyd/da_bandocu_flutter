import 'package:flutter/material.dart';
import '../../../route/route_constants.dart';
import 'components/ProductItem.dart';

class ManagerProduct extends StatelessWidget {
  const ManagerProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách sản phẩm'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, managerAddProductRoute);
            },
          ),
        ],
      ),
      body: ListView(
        children: const [
          ProductItem(
            productName: 'Sản phẩm 1',
            productPrice: '100.000 VND',
            productImage: 'https://via.placeholder.com/150',
            productCategory: 'Danh mục 1',
          ),
          ProductItem(
            productName: 'Sản phẩm 2',
            productPrice: '200.000 VND',
            productImage: 'https://via.placeholder.com/150',
            productCategory: 'Danh mục 2',
          ),
          ProductItem(
            productName: 'Sản phẩm 3',
            productPrice: '300.000 VND',
            productImage: 'https://via.placeholder.com/150',
            productCategory: 'Danh mục 3',
          ),
          // Thêm nhiều sản phẩm hơn ở đây
        ],
      ),
    );
  }
}
