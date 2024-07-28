import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class BaseService {
  final String baseUrl = 'http://192.168.0.100:5000/api/';
  final IOClient client;

  BaseService({http.Client? client})
      : client = IOClient(
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true,
        );

  Future<http.Response> insertOrUpdateAsync(
      String endpoint, Object data) async {
    final response = await client.post(
      Uri.parse('$baseUrl$endpoint/InsertOrUpdate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      log('response: $response');
    }

    return response;
  }

  Future<http.Response> getListAsync(String endpoint, Object data) async {
    final response = await client.post(
      Uri.parse('$baseUrl$endpoint/GetList'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      log('response: $response');
    }

    return response;
  }

  Future<http.Response> getListCommonAsync(
      String endpoint, String router, Object data) async {
    final response = await client.post(
      Uri.parse('$baseUrl$endpoint$router'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      log('response: $response');
    }

    return response;
  }

  Future<http.Response> delete(String endpoint, String paramId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl$endpoint/Delete?$paramId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      log('response: $response');
    }

    return response;
  }

  Future<http.Response> fetchAsync(
      String endpoint, String router, Object data) async {
    final response = await client.post(
      Uri.parse('$baseUrl$endpoint$router'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: data.runtimeType == String ? data : jsonEncode(data),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      log('response: $response');
    }

    return response;
  }

  Future<http.Response> getByParam(
      String endpoint, String param, Object data) async {
    final response = await client.post(
      Uri.parse('$baseUrl$endpoint/$param'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      log('response: $response');
    }

    return response;
  }
}


// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:http/io_client.dart';

// import '../constants.dart';

// class BaseService {
//   final IOClient client;

//   BaseService({http.Client? client})
//       : client = IOClient(
//           HttpClient()
//             ..badCertificateCallback =
//                 (X509Certificate cert, String host, int port) => true,
//         );

//   Future<http.Response> insertOrUpdateAsync(
//       String endpoint, Object data) async {
//     final response = await client.post(
//       Uri.parse('$apiUrl/$endpoint/InsertOrUpdate'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(data),
//     );

//     if (response.statusCode < 200 || response.statusCode >= 300) {
//       log('response: $response');
//     }

//     return response;
//   }

//   Future<http.Response> getListAsync(String endpoint, Object data) async {
//     final response = await client.post(
//       Uri.parse('$apiUrl/$endpoint/GetList'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(data),
//     );

//     if (response.statusCode < 200 || response.statusCode >= 300) {
//       log('response: $response');
//     }

//     return response;
//   }

//   Future<http.Response> fetchAsync(
//       String endpoint, String router, Object data) async {
//     final response = await client.post(
//       Uri.parse('$apiUrl/$endpoint$router'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: data.runtimeType == String ? data : jsonEncode(data),
//     );

//     if (response.statusCode < 200 || response.statusCode >= 300) {
//       log('response: $response');
//     }

//     return response;
//   }

//   Future<http.Response> delete(String endpoint, String paramId) async {
//     final response = await client.delete(
//       Uri.parse('$apiUrl/$endpoint/Delete?$paramId'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//     );

//     if (response.statusCode < 200 || response.statusCode >= 300) {
//       log('response: $response');
//     }

//     return response;
//   }

//   Future<http.Response> getByParam(
//       String endpoint, String param, Object data) async {
//     final response = await client.post(
//       Uri.parse('$apiUrl/$endpoint/$param'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(data),
//     );

//     if (response.statusCode < 200 || response.statusCode >= 300) {
//       log('response: $response');
//     }

//     return response;
//   }
// }
