class AppUser {
  final int id;
  final String name;
  final String email;
  final String? role;
  final String? phone;

  AppUser({required this.id, required this.name, required this.email, this.role, this.phone});

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        role: json['role'] as String?,
        phone: json['phone'] as String?,
      );
}
