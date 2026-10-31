import 'dart:convert';
import '../../domain/entities/user_entity.dart';

/// Data Model implementing serialization for UserEntity
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    super.birthDate,
    super.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? 'usr_1',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      birthDate: json['birthDate'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'birthDate': birthDate,
      'profileImageUrl': profileImageUrl,
    };
  }

  String toRawJson() => jsonEncode(toJson());

  factory UserModel.fromRawJson(String raw) =>
      UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}

