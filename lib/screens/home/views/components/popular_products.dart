import 'package:flutter/material.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/screen_export.dart';
import 'package:shop/service/views/home_service.dart';

import '../../../../constants.dart';

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

class PopularProducts extends StatelessWidget {
  const PopularProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final param = {"currentPage": 1, "pageSize": 20, "textSearch": ""};
    late Future<List<Map<Object, dynamic>>> _popularProducts = HomeService().getListHome(param);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Sản phẩm nổi bật",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading use 👇
        // const ProductsSkelton(),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<Map<Object, dynamic>>>(
        future: _popularProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No home found'));
          } else {
            final popularProducts = snapshot.data!;
            return ListView.builder(
            scrollDirection: Axis.horizontal,
            // Find demoPopularProducts on models/ProductModel.dart
            itemCount: popularProducts.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: defaultPadding,
                right: index == popularProducts.length - 1
                    ? defaultPadding
                    : 0,
              ),
              child: ProductCard(
                image: popularProducts[index]["image"],
                brandName: popularProducts[index]["brandName"],
                title: popularProducts[index]["title"],
                price: popularProducts[index]["price"],
                priceAfetDiscount: popularProducts[index]["priceAfetDiscount"],
                dicountpercent: popularProducts[index]["dicountpercent"],
                press: () {
                  Navigator.pushNamed(context, productDetailsScreenRoute,
                      arguments: popularProducts[index]["productId"]);
                },
              ),
            ),
          );
          }
        },
      ),
        )
      ],
    );
  }
}
