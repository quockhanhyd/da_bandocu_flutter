import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
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

  Future<Map<Object, dynamic>> getOrderDetails(Object orderId) async {
    var param = {"orderId": orderId}; // Thay đổi key nếu cần thiết

    final response = await getByParam(urlName, "GetById", param);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Kiểm tra cấu trúc dữ liệu trả về từ API
      final order = responseData['data']['order'];
      final List<dynamic> orderDetail = responseData['data']['orderDetail'];

      // Trả về bản đồ chứa thông tin đơn hàng và danh sách chi tiết đơn hàng
      return {
        'order': order,
        'orderDetail': orderDetail,
      };
    } else {
      log('Error: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception('Failed to load order details');
    }
  }

  Future<bool> updateStatusAsync(Object data) async {
    final response = await getByParam(urlName, "UpdateStatus", data);

    if (response.statusCode == 200) {
      return true;
    } else {
      log('error: $response');
    }
    return false;
  }
}
