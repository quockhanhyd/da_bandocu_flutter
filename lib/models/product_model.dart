// For demo only
import 'package:shop/constants.dart';

class ProductModel {
  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;

  ProductModel({
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
  });
}
List<ProductModel> demoBestSellersProducts = [
  ProductModel(
    image: "https://i.imgur.com/tXyOMMG.png",
    title: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    price: 650.62,
    priceAfetDiscount: 390.36,
    dicountpercent: 40,
  ),
  ProductModel(
    image: "https://i.imgur.com/h2LqppX.png",
    title: "white satin corset top",
    brandName: "Lipsy london",
    price: 1264,
    priceAfetDiscount: 1200.8,
    dicountpercent: 5,
  ),
  ProductModel(
    image: productDemoImg4,
    title: "Mountain Beta Warehouse",
    brandName: "Lipsy london",
    price: 800,
    priceAfetDiscount: 680,
    dicountpercent: 15,
  ),
];
List<ProductModel> kidsProducts = [
  ProductModel(
    image: "https://i.imgur.com/dbbT6PA.png",
    title: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    price: 650.62,
    priceAfetDiscount: 590.36,
    dicountpercent: 24,
  ),
  ProductModel(
    image: "https://i.imgur.com/7fSxC7k.png",
    title: "Printed Sleeveless Tiered Swing Dress",
    brandName: "Lipsy london",
    price: 650.62,
  ),
  ProductModel(
    image: "https://i.imgur.com/pXnYE9Q.png",
    title: "Ruffle-Sleeve Ponte-Knit Sheath ",
    brandName: "Lipsy london",
    price: 400,
  ),
  ProductModel(
    image: "https://i.imgur.com/V1MXgfa.png",
    title: "Green Mountain Beta Warehouse",
    brandName: "Lipsy london",
    price: 400,
    priceAfetDiscount: 360,
    dicountpercent: 20,
  ),
  ProductModel(
    image: "https://i.imgur.com/8gvE5Ss.png",
    title: "Printed Sleeveless Tiered Swing Dress",
    brandName: "Lipsy london",
    price: 654,
  ),
  ProductModel(
    image: "https://i.imgur.com/cBvB5YB.png",
    title: "Mountain Beta Warehouse",
    brandName: "Lipsy london",
    price: 250,
  ),
];


class ProductModel2 {
  final int productID;
  final String productName;
  final int totalAmount;
  final int totalSold;
  final int vote;
  final int price;
  final int priceSale;
  final int percentSale;
  final String description;
  final String imageUrl;
  final int categoryID;
  final String categoryName;
  ProductModel2({
    required this.productID,
    required this.productName,
    required this.totalAmount,
    required this.totalSold,
    required this.vote,
    required this.price,
    required this.priceSale,
    required this.percentSale,
    required this.description,
    required this.imageUrl,
    required this.categoryID,
    required this.categoryName,
  });

  factory ProductModel2.fromJson(Map<String, dynamic> json) {
    return ProductModel2(
      productID: json['productID'],
      productName: json['productName'],
      totalAmount: json['totalAmount'],
      totalSold: json['totalSold'],
      vote: json['vote'],
      price: json['price'],
      priceSale: json['priceSale'],
      percentSale: json['percentSale'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      categoryID: json['categoryID'],
      categoryName: json['categoryName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productID': productID,
      'productName': productName,
      'totalAmount': totalAmount,
      'totalSold': totalSold,
      'vote': vote,
      'price': price,
      'priceSale': priceSale,
      'percentSale': percentSale,
      'description': description,
      'imageUrl': imageUrl,
      'categoryID': categoryID,
    };
  }
}
