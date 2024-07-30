import 'dart:convert';
import 'dart:developer';

import 'package:shop/service/base_service.dart';

class AuthService extends BaseService {
  AuthService() : super();
  static String urlName = 'Authentication';

  Future<Map<Object, dynamic>> LoginAsync(Object data) async {
    final response = await getByParam(urlName, "SignIn", data);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['isOk'] == true) {
        final data = responseData['data'] as Map<Object, dynamic>;

        // Trả về dữ liệu người dùng dưới dạng Map<Object, dynamic>
        return data;
      } else {
        log('Error: ${responseData['errorMessage']}');
        throw Exception('Failed to login');
      }
    } else {
      log('Error: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception('Failed to load data');
    }
  }
}
