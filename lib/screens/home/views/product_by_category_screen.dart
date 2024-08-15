import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/service/views/home_service.dart';

import '../../../constants.dart';

class ProductByCategoryScreen extends StatelessWidget {
  final String categoryID;
  const ProductByCategoryScreen({super.key, required this.categoryID});

  @override
  Widget build(BuildContext context) {
    // Sử dụng FutureBuilder để xử lý dữ liệu bất đồng bộ từ API
    return Scaffold(
      body: FutureBuilder<List<Map<Object, dynamic>>>(
        future: HomeService().GetListByCategoryID(categoryID),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<Object, dynamic>>> snapshot) {
          // Kiểm tra trạng thái của snapshot
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Hiển thị spinner loading khi đang chờ dữ liệu
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Xử lý lỗi nếu có
            return Center(child: Text('Đã xảy ra lỗi!'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Xử lý khi không có dữ liệu
            return Center(child: Text('Không có sản phẩm nào.'));
          } else {
            // Khi có dữ liệu, hiển thị các sản phẩm
            List<Map<Object, dynamic>> _listProduct = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  floating: true,
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset("assets/icons/Bookmark.svg",
                          color: Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                      mainAxisSpacing: defaultPadding,
                      crossAxisSpacing: defaultPadding,
                      childAspectRatio: 0.66,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final product = _listProduct[index];
                        return ProductCard(
                          image: (product['imageUrl'] ?? "").split(',')[0],
                          brandName: "SECOND HAND",
                          title: product['productName'],
                          price: product['price'],
                          priceAfetDiscount: product['priceSale'],
                          dicountpercent: product['percentSale'],
                          press: () {
                            Navigator.pushNamed(
                                context, productDetailsScreenRoute,
                                arguments: product['productID']);
                          },
                        );
                      },
                      childCount: _listProduct.length,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
