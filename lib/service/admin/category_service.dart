import 'dart:convert';
import 'dart:developer';

import '../base_service.dart';

class CategoryService extends BaseService {
  CategoryService() : super();
  static String urlName = 'Category';
  Future<bool> insertOrUpdateCategoryAsync(Object data) async {
    final response = await insertOrUpdateAsync(urlName, data);

    if (response.statusCode == 200) {
      return true;
    } else {
      log('error: $response');
    }
    return false;
  }

  Future<List<Map<Object, dynamic>>> getCategories(Object data) async {
    final response = await getListAsync(urlName, data);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> dataList = responseData['data']['data'];

      // Chuyển đổi dữ liệu thành List<Map<String, dynamic>>
      return dataList.map((item) => item as Map<Object, dynamic>).toList();
    } else {
      log('Error: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception('Failed to load categories');
    }
  }

  Future<bool> deleteCategory(int categoryID) async {
    var param = 'CategoryID=$categoryID';
    final response = await delete(urlName, param);

    if (response.statusCode == 200) {
      return true;
    } else {
      log('error: $response');
    }
    return false;
  }

}
