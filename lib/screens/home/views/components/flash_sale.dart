import 'package:flutter/material.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/service/views/home_service.dart';

import '/components/Banner/M/banner_m_with_counter.dart';
import '../../../../components/product/product_card.dart';
import '../../../../constants.dart';
import '../../../../models/product_model.dart';

List<ProductModel> flashSaleProducts = [
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
    image: productDemoImg4,
    productName: "Mountain Beta Warehouse",
    brandName: "Lipsy london",
    price: 800,
    priceAfetDiscount: 680,
    dicountpercent: 15,
  ),
];

class FlashSale extends StatelessWidget {
  const FlashSale({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final param = {"currentPage": 1, "pageSize": 20, "textSearch": ""};
    late Future<List<Map<Object, dynamic>>> _flashSaleProducts =
        HomeService().getListHome(param);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // While loading show 👇
        // const BannerMWithCounterSkelton(),
        BannerMWithCounter(
          duration: const Duration(hours: 8),
          text: "Siêu khuyển mãi \n50%",
          press: () {},
        ),
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Siêu khuyến mãi",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading show 👇
        // const ProductsSkelton(),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<Map<Object, dynamic>>>(
            future: _flashSaleProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No home found'));
              } else {
                final flashSaleProducts = snapshot.data!;
                flashSaleProducts.sort((a, b) =>
                    a["dicountpercent"] < b["dicountpercent"] ? 1 : 0);
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // Find flashSaleProducts on models/ProductModel.dart
                    itemCount: flashSaleProducts.length,
                    itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(
                            left: defaultPadding,
                            right: index == flashSaleProducts.length - 1
                                ? defaultPadding
                                : 0,
                          ),
                          child: ProductCard(
                            image:
                                flashSaleProducts[index]["image"].split(',')[0],
                            brandName: flashSaleProducts[index]["brandName"],
                            title: flashSaleProducts[index]["productName"],
                            price: flashSaleProducts[index]["price"],
                            priceAfetDiscount: flashSaleProducts[index]
                                ["priceAfetDiscount"],
                            dicountpercent: flashSaleProducts[index]
                                ["dicountpercent"],
                            press: () {
                              Navigator.pushNamed(
                                  context, productDetailsScreenRoute,
                                  arguments: flashSaleProducts[index]
                                      ["productId"]);
                            },
                          ),
                        ));
              }
            },
          ),
        ),
      ],
    );
  }
}
