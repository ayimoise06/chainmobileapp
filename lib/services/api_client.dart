import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);
}

class ApiClient {
  ApiClient({
    required this.baseUrl,
    http.Client? client,
    Future<String?> Function()? tokenProvider,
  })  : _client = client ?? http.Client(),
        _tokenProvider = tokenProvider;

  final String baseUrl;
  final http.Client _client;
  final Future<String?> Function()? _tokenProvider;

  Future<Map<String, dynamic>> getJson(
    String path, {
    bool withAuth = false,
  }) async {
    final response = await _client.get(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(withAuth: withAuth),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body, {
    bool withAuth = false,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(withAuth: withAuth),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<Map<String, String>> _headers({required bool withAuth}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (withAuth && _tokenProvider != null) {
      final token = await _tokenProvider!();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    String message = 'Une erreur est survenue.';
    if (response.body.isNotEmpty) {
      try {
        final payload = jsonDecode(response.body) as Map<String, dynamic>;
        if (payload['message'] is String) {
          message = payload['message'] as String;
        }
      } catch (_) {}
    }
    throw ApiException(response.statusCode, message);
  }
}
