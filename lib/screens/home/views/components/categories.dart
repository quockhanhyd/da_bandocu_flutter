import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/service/admin/category_service.dart';

import '../../../../constants.dart';

// For preview
class CategoryModel {
  final String name;
  final String? svgSrc, route;

  CategoryModel({
    required this.name,
    this.svgSrc,
    this.route,
  });
}

class Categories extends StatelessWidget {
  const Categories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final param = {"currentPage": 1, "pageSize": 20, "textSearch": ""};
    return FutureBuilder<List<CategoryModel2>>(
      future: CategoryService().getCategories(param),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CategoryModel2> data = snapshot.data!;
          data.insert(
              0,
              CategoryModel2(
                  categoryID: 0, productCount: 0, categoryName: "Tất cả"));
          // data.insert(
          //     1,
          //     CategoryModel2(
          //         categoryID: 0,
          //         productCount: 0,
          //         categoryName: "Sản phẩm khuyến mãi",
          //         description: "assets/icons/Sale.svg"));
          return SizedBox(
            height: 40, // Set a fixed height
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(
                  left: defaultPadding,
                  right: index == data.length - 1 ? defaultPadding : 0,
                ),
                child: CategoryBtn(
                  category: data[index].categoryName ?? "",
                  svgSrc: data[index].description,
                  isActive: index == 0,
                  press: () {
                    Navigator.pushNamed(
                      context,
                      productByCategory,
                      arguments: data[index].categoryID.toString(),
                    );
                  },
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

class CategoryBtn extends StatelessWidget {
  const CategoryBtn({
    super.key,
    required this.category,
    this.svgSrc,
    required this.isActive,
    required this.press,
  });

  final String category;
  final String? svgSrc;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.transparent,
          border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : Theme.of(context).dividerColor),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          children: [
            if (svgSrc != null)
              SvgPicture.asset(
                svgSrc!,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isActive ? Colors.white : Theme.of(context).iconTheme.color!,
                  BlendMode.srcIn,
                ),
              ),
            if (svgSrc != null) const SizedBox(width: defaultPadding / 2),
            Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
