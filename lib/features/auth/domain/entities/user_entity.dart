/// Clean Architecture Entity representing an authenticated User.
class UserEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? birthDate;
  final String? profileImageUrl;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.birthDate,
    this.profileImageUrl,
  });

  String get fullName => '$firstName $lastName'.trim();

  UserEntity copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? birthDate,
    String? profileImageUrl,
  }) {
    return UserEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}

