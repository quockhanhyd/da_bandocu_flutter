import 'package:flutter/material.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/service/views/home_service.dart';

import '../../../../constants.dart';
import '../../../../route/route_constants.dart';

class BestSellers extends StatelessWidget {
  const BestSellers({
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
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Được mua nhiều",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading use 👇
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
                    a["priceAfetDiscount"] < b["priceAfetDiscount"] ? 1 : 0);
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
                      image: flashSaleProducts[index]["image"].split(',')[0],
                      brandName: flashSaleProducts[index]["brandName"],
                      title: flashSaleProducts[index]["productName"],
                      price: flashSaleProducts[index]["price"],
                      priceAfetDiscount: flashSaleProducts[index]
                          ["priceAfetDiscount"],
                      dicountpercent: flashSaleProducts[index]
                          ["dicountpercent"],
                      press: () {
                        Navigator.pushNamed(context, productDetailsScreenRoute,
                            arguments: flashSaleProducts[index]["productId"]);
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
