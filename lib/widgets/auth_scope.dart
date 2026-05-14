import 'package:flutter/widgets.dart';

import '../state/auth_state.dart';

class AuthScope extends InheritedNotifier<AuthState> {
  const AuthScope({
    super.key,
    required AuthState notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static AuthState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthScope>();
    if (scope == null) {
      throw StateError('AuthScope not found in context.');
    }
    return scope.notifier!;
  }
}
