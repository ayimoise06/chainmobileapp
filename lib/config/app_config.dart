import 'package:flutter/foundation.dart';

class AppConfig {
  static String get apiBaseUrl {
    const fromEnv = String.fromEnvironment('API_BASE_URL');
    final resolved = fromEnv.isNotEmpty
        ? fromEnv
        : defaultTargetPlatform == TargetPlatform.android
            ? 'http://10.0.2.2:4000'
            : 'http://localhost:4000';

    if (resolved.trim().isEmpty) {
      throw StateError('API_BASE_URL is required.');
    }

    final parsed = Uri.tryParse(resolved);
    if (parsed == null || !parsed.hasScheme || parsed.host.isEmpty) {
      throw StateError('API_BASE_URL is invalid.');
    }

    if (kReleaseMode && resolved.startsWith('http://')) {
      throw StateError('API_BASE_URL must use HTTPS in release builds.');
    }

    return resolved;
  }
}
