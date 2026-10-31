import '../entities/user_entity.dart';

/// Repository interface for User Authentication following Clean Architecture
abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> login({required String email, required String password});
  Future<UserEntity> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String birthDate,
    required String password,
  });
  Future<void> forgotPassword({required String email, required String phone});
  Future<void> logout();
  Future<UserEntity> updateProfile({required String firstName, required String lastName, String? photoUrl});
}

