import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/service/views/home_service.dart';

import '../../../constants.dart';

List<ProductModel> demoPopularProducts = [
  ProductModel(
    image: productDemoImg1,
    productName: "Mountain Warehouse for Women",
    brandName: "Lipsy london",
    price: 540,
    priceAfetDiscount: 420,
    dicountpercent: 20,
  ),
  ProductModel(
    image: productDemoImg4,
    productName: "Mountain Beta Warehouse",
    brandName: "Lipsy london",
    price: 800,
  ),
  ProductModel(
    image: productDemoImg5,
    productName: "FS - Nike Air Max 270 Really React",
    brandName: "Lipsy london",
    price: 650,
    priceAfetDiscount: 390,
    dicountpercent: 40,
  ),
  ProductModel(
    image: productDemoImg6,
    productName: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    price: 1264,
    priceAfetDiscount: 1200,
    dicountpercent: 5,
  ),
  ProductModel(
    image: "https://i.imgur.com/tXyOMMG.png",
    productName: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    price: 650,
    priceAfetDiscount: 390,
    dicountpercent: 40,
  ),
  ProductModel(
    image: "https://i.imgur.com/h2LqppX.png",
    productName: "white satin corset top",
    brandName: "Lipsy london",
    price: 1264,
    priceAfetDiscount: 1200,
    dicountpercent: 5,
  ),
];

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<Object, dynamic>>>(
        future: HomeService().GetListByCategoryID("1"),
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
