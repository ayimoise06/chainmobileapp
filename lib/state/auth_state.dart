import 'package:flutter/foundation.dart';

import '../models/auth_models.dart';
import '../services/auth_service.dart';

class AuthState extends ChangeNotifier {
  AuthState(this._service);

  final AuthService _service;

  AuthSession? _session;
  bool _loading = false;
  bool _sessionExpired = false;

  AuthSession? get session => _session;
  bool get isLoading => _loading;
  bool get sessionExpired => _sessionExpired;

  Future<void> loadSession() async {
    _loading = true;
    notifyListeners();
    try {
      _session = await _service.restoreSession();
    } on AuthException catch (error) {
      if (error.sessionExpired) {
        _sessionExpired = true;
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<AuthSession> login({
    required String email,
    required String password,
    required String role,
  }) async {
    _loading = true;
    notifyListeners();
    try {
      _session = await _service.login(email: email, password: password, role: role);
      _sessionExpired = false;
      return _session!;
    } finally {
      _loading = false;
      notifyListeners();
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
    _loading = true;
    notifyListeners();
    try {
      _session = await _service.register(
        email: email,
        password: password,
        role: role,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
      _sessionExpired = false;
      return _session!;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _loading = true;
    notifyListeners();
    await _service.clearSession();
    _session = null;
    _sessionExpired = false;
    _loading = false;
    notifyListeners();
  }

  void clearSessionExpired() {
    _sessionExpired = false;
    notifyListeners();
  }
}
