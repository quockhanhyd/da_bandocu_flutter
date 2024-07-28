import 'dart:convert';
import 'dart:developer';
import 'package:shop/models/cart_model.dart';

import '../base_service.dart';

class CartService extends BaseService {
  CartService() : super();
  static String urlName = 'Cart';

  Future<String> order(Object data) async {
    final response = await fetchAsync(urlName, "/Order", data);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data'];
    } else {
      log('error: ${response.statusCode} - ${response.body}');
    }
    return "";
  }

  Future<bool> addToCart(Object data) async {
    final response = await fetchAsync(urlName, "/AddToCart", data);

    if (response.statusCode == 200) {
      return true;
    } else {
      log('error: ${response.statusCode} - ${response.body}');
    }
    return false;
  }

  Future<bool> insertOrUpdateCartAsync(Object data) async {
    final response = await insertOrUpdateAsync(urlName, data);

    if (response.statusCode == 200) {
      return true;
    } else {
      log('error: $response');
    }
    return false;
  }

  Future<List<CartModel>> getList(Object data) async {
    final response = await getListAsync(urlName, data);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> dataList = responseData['data']['data'];

      // Chuyển đổi danh sách JSON thành danh sách các đối tượng ProductModel2
      return dataList
          .map((item) => CartModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      log('Error: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception('Failed to load categories');
    }
  }

  Future<bool> deleteCart(int CartID) async {
    var param = 'CartID=$CartID';
    final response = await delete(urlName, param);

    if (response.statusCode == 200) {
      return true;
    } else {
      log('error: $response');
    }
    return false;
  }
}
