import 'package:flutter/material.dart';
import 'package:shop/components/Banner/S/banner_s_style_1.dart';
import 'package:shop/components/Banner/S/banner_s_style_5.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/screen_export.dart';

import 'components/best_sellers.dart';
import 'components/flash_sale.dart';
import 'components/most_popular.dart';
import 'components/offer_carousel_and_categories.dart';
import 'components/popular_products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: OffersCarouselAndCategories()),
            SliverToBoxAdapter(child: PopularProducts()),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 0),
              // padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
              sliver: SliverToBoxAdapter(child: FlashSale()),
            ),
            // SliverToBoxAdapter(
            //   child: Column(
            //     children: [
            //       // While loading use 👇
            //       // const BannerMSkelton(),‚
            //       BannerSStyle1(
            //         title: "Mới \ncập bến",
            //         subtitle: "Ưu đãi đặc biệt",
            //         discountParcent: 50,
            //         press: () {
            //           Navigator.pushNamed(context, onSaleScreenRoute);
            //         },
            //       ),
            //       const SizedBox(height: defaultPadding / 4),
            //       // We have 4 banner styles, all in the pro version
            //     ],
            //   ),
            // ),
            SliverToBoxAdapter(child: BestSellers()),
            SliverToBoxAdapter(child: MostPopular()),
          ],
        ),
      ),
    );
  }
}
