import 'dart:convert';
import 'dart:developer';

import 'package:shop/models/order_model.dart';

import '../../models/category_model.dart';
import '../base_service.dart';

class OrderAdminService extends BaseService {
  OrderAdminService() : super();
  static String urlName = 'Order';

  // Future<bool> insertOrUpdateCategoryAsync(Object data) async {
  //   final response = await insertOrUpdateAsync(urlName, data);
  //
  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {
  //     log('error: $response');
  //   }
  //   return false;
  // }

  Future<List<Map<String, dynamic>>> getOrdersByMerchanIDAsync(
      Map<String, dynamic> data) async {
    final response =
        await getByParam(urlName, "GetTotalOrderByMerchanID", data);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Kiểm tra dữ liệu và đảm bảo dữ liệu là danh sách
      if (responseData['data'] is List) {
        final List<dynamic> dataList = responseData['data'];

        // Chuyển đổi dữ liệu thành List<Map<String, dynamic>>
        return dataList.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        // Trả về danh sách rỗng nếu dữ liệu không đúng định dạng
        return [];
      }
    } else {
      log('Error: ${response.statusCode} ${response.reasonPhrase}');
      // Trả về danh sách rỗng trong trường hợp có lỗi
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> GetByStatus(int status) async {
    var param = {"status": status}; // Đổi key thành "status" cho phù hợp

    final response = await getByParam(urlName, "GetByStatus", param);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Kiểm tra dữ liệu và đảm bảo dữ liệu là danh sách
      if (responseData['data']['data'] is List) {
        final List<dynamic> dataList = responseData['data']['data'];

        // Chuyển đổi dữ liệu thành List<Map<String, dynamic>>
        return dataList.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        return []; // Trả về danh sách rỗng nếu dữ liệu không đúng định dạng
      }
    } else {
      log('Error: ${response.statusCode} ${response.reasonPhrase}');
      return []; // Trả về danh sách rỗng trong trường hợp có lỗi
    }
  }

  Future<List<OrderDetail>> getOrderDetails(Object data) async {
    final response = await getListAsync(urlName, data);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> dataList = responseData['data']['data'];

      // Chuyển đổi danh sách JSON thành danh sách các đối tượng ProductModel2
      return dataList
          .map((item) => OrderDetail.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      log('Error: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception('Failed to load categories');
    }
  }
}
