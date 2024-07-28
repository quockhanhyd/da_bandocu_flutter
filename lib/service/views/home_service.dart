import 'dart:convert';
import 'dart:developer';

import '../base_service.dart';

class HomeService extends BaseService {
  HomeService() : super();
  static String urlName = 'Product';
  Future<List<Map<Object, dynamic>>> getListHome(Object data) async {
    final response = await fetchAsync(urlName, "/GetListHome", data);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> dataList = responseData['data']['data'];

      // Chuyển đổi dữ liệu thành List<Map<String, dynamic>>
      return dataList.map((item) => item as Map<Object, dynamic>).toList();
    } else {
      log('Error: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception('Failed to load home');
    }
  }

  Future<Map<Object, dynamic>> getDetail(Object data) async {
    final response = await fetchAsync(urlName, "/GetDetail", data);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final dynamic data = responseData['data'];

      return data as Map<Object, dynamic>;
    } else {
      log('Error: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception('Failed to load detail');
    }
  }
}
