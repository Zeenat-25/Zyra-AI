class User {
  final int? id;
  final String name;
  final String? email;
  final String phone;
  final String createdAt;

  const User({
    this.id,
    required this.name,
    this.email,
    required this.phone,
    required this.createdAt,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
