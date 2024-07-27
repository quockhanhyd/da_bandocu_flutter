// For demo only
import 'package:shop/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<ProductModel> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('$apiUrl/Product/GetOne'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ProductModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class ProductModel {
  final int? productID;
  final String? image, brandName, productName;
  final int? price;
  final int? priceAfetDiscount;
  final int? dicountpercent;

  ProductModel({
    this.productID,
    this.image,
    this.brandName,
    this.productName,
    this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'productID': int productID,
        'productName': String productName,
      } =>
        ProductModel(
          productID: productID,
          productName: productName,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
List<ProductModel> demoBestSellersProducts = [
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
  ProductModel(
    image: productDemoImg4,
    productName: "Mountain Beta Warehouse",
    brandName: "Lipsy london",
    price: 800,
    priceAfetDiscount: 680,
    dicountpercent: 15,
  ),
];
List<ProductModel> kidsProducts = [
  ProductModel(
    image: "https://i.imgur.com/dbbT6PA.png",
    productName: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    price: 650,
    priceAfetDiscount: 590,
    dicountpercent: 24,
  ),
  ProductModel(
    image: "https://i.imgur.com/7fSxC7k.png",
    productName: "Printed Sleeveless Tiered Swing Dress",
    brandName: "Lipsy london",
    price: 650,
  ),
  ProductModel(
    image: "https://i.imgur.com/pXnYE9Q.png",
    productName: "Ruffle-Sleeve Ponte-Knit Sheath ",
    brandName: "Lipsy london",
    price: 400,
  ),
  ProductModel(
    image: "https://i.imgur.com/V1MXgfa.png",
    productName: "Green Mountain Beta Warehouse",
    brandName: "Lipsy london",
    price: 400,
    priceAfetDiscount: 360,
    dicountpercent: 20,
  ),
  ProductModel(
    image: "https://i.imgur.com/8gvE5Ss.png",
    productName: "Printed Sleeveless Tiered Swing Dress",
    brandName: "Lipsy london",
    price: 654,
  ),
  ProductModel(
    image: "https://i.imgur.com/cBvB5YB.png",
    productName: "Mountain Beta Warehouse",
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
      price: (json['price'] as num).toInt(), // Chuyển đổi int hoặc double thành double
      priceSale: (json['priceSale'] as num).toInt(), // Chuyển đổi int hoặc double thành double
      percentSale: json['percentSale'], // Chuyển đổi int hoặc double thành double
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
