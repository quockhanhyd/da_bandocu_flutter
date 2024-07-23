import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
class BaseService {
  final String baseUrl = 'https://192.168.0.107:7156/api/';
  final IOClient client;

  BaseService({http.Client? client})
      : client = IOClient(
        HttpClient()
          ..badCertificateCallback = (X509Certificate cert, String host, int port) => true,
      );

  Future<http.Response> insertOrUpdateAsync(String endpoint, Object data) async {
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
}
