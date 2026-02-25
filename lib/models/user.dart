class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String occupation;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    required this.occupation,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] ?? json;

    return User(
      id: userData['id'] as int,
      name: userData['name'] as String,
      email: userData['email'] as String,
      phone: userData['phone'] as String?,
      avatar: userData['avatar'] as String?,
      occupation: userData['occupation'] as String? ?? 'N/A',
    );
  }
}
