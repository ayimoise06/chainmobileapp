class AuthUser {
  final String id;
  final String email;
  final String role;
  final String? firstName;
  final String? lastName;
  final String? phone;

  const AuthUser({
    required this.id,
    required this.email,
    required this.role,
    this.firstName,
    this.lastName,
    this.phone,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String?,
    );
  }
}

class AuthSession {
  final String token;
  final AuthUser user;

  const AuthSession({required this.token, required this.user});
}

class AuthRoles {
  static const String farmer = 'farmer';
  static const String cooperative = 'cooperative';
  static const String exporter = 'exporter';

  static String fromDisplay(String roleLabel) {
    switch (roleLabel) {
      case 'Agriculteur':
        return farmer;
      case 'Coopérative':
        return cooperative;
      case 'Exportateur':
        return exporter;
      default:
        return farmer;
    }
  }

  static String toDisplay(String role) {
    switch (role) {
      case farmer:
        return 'Agriculteur';
      case cooperative:
        return 'Coopérative';
      case exporter:
        return 'Exportateur';
      default:
        return 'Agriculteur';
    }
  }
}
