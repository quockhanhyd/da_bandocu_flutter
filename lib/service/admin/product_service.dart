import 'dart:convert';
import 'dart:developer';

import '../../models/product_model.dart';
import '../base_service.dart';

class ProductService extends BaseService {
  ProductService() : super();
  static String urlName = 'Product';
  Future<bool> insertOrUpdateProductAsync(Object data) async {
    final response = await insertOrUpdateAsync(urlName, data);

    if (response.statusCode == 200) {
      return true;
    } else {
      log('error: $response');
    }
    return false;
  }

  Future<List<ProductModel2>> getProducts(Object data) async {
    final response = await getListAsync(urlName, data);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> dataList = responseData['data']['data'];

      // Chuyển đổi danh sách JSON thành danh sách các đối tượng ProductModel2
      return dataList.map((item) => ProductModel2.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      log('Error: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception('Failed to load products');
    }
  }

  Future<bool> deleteProduct(int productId) async {
    var param = 'ProductID=$productId';
    final response = await delete(urlName, param);

    if (response.statusCode == 200) {
      return true;
    } else {
      log('error: $response');
    }
    return false;
  }

}
