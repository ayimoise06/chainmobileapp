import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_config.dart';
import '../models/auth_models.dart';
import 'api_client.dart';

class AuthException implements Exception {
  final String message;
  final bool sessionExpired;

  AuthException(this.message, {this.sessionExpired = false});
}

class AuthService {
  AuthService({
    FlutterSecureStorage? secureStorage,
    ApiClient? apiClient,
  })  : _storage = secureStorage ?? const FlutterSecureStorage(),
        _client = apiClient ??
            ApiClient(
              baseUrl: AppConfig.apiBaseUrl,
            );

  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage;
  final ApiClient _client;

  Future<AuthSession> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final data = await _client.postJson('/auth/login', {
        'email': email,
        'password': password,
        'role': role,
      });
      final session = _parseSession(data);
      await _storage.write(key: _tokenKey, value: session.token);
      return session;
    } on ApiException catch (error) {
      throw AuthException(error.message, sessionExpired: error.statusCode == 401);
    }
  }

  Future<AuthSession> register({
    required String email,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    try {
      final data = await _client.postJson('/auth/register', {
        'email': email,
        'password': password,
        'role': role,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
      });
      final session = _parseSession(data);
      await _storage.write(key: _tokenKey, value: session.token);
      return session;
    } on ApiException catch (error) {
      throw AuthException(error.message, sessionExpired: error.statusCode == 401);
    }
  }

  Future<AuthSession?> restoreSession() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null || token.isEmpty) {
      return null;
    }

    final client = ApiClient(
      baseUrl: AppConfig.apiBaseUrl,
      tokenProvider: () async => token,
    );

    try {
      final data = await client.getJson('/auth/me', withAuth: true);
      final user = AuthUser.fromJson(data['user'] as Map<String, dynamic>);
      return AuthSession(token: token, user: user);
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        await clearSession();
      }
      throw AuthException(error.message, sessionExpired: error.statusCode == 401);
    }
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
  }

  AuthSession _parseSession(Map<String, dynamic> data) {
    final user = AuthUser.fromJson(data['user'] as Map<String, dynamic>);
    return AuthSession(token: data['token'] as String, user: user);
  }
}
