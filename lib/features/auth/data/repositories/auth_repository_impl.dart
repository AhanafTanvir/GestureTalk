import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

/// Concrete implementation of AuthRepository with persistence
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(AppConstants.authUserKey);
      if (userJson != null) {
        return UserModel.fromRawJson(userJson);
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    // Simulated network/auth delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Simple validation test
    if (password.length < 4) {
      throw Exception('Invalid password credentials.');
    }

    final user = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      firstName: 'Abhijit',
      lastName: 'Bhowmik',
      email: email,
      phone: '01916147408',
      birthDate: '02/January/2026',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.authUserKey, user.toRawJson());
    return user;
  }

  @override
  Future<UserEntity> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String birthDate,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final user = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      birthDate: birthDate,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.authUserKey, user.toRawJson());
    return user;
  }

  @override
  Future<void> forgotPassword({
    required String email,
    required String phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.authUserKey);
  }

  @override
  Future<UserEntity> updateProfile({
    required String firstName,
    required String lastName,
    String? photoUrl,
  }) async {
    final current = await getCurrentUser();
    final updated = UserModel(
      id: current?.id ?? 'usr_1',
      firstName: firstName,
      lastName: lastName,
      email: current?.email ?? 'gestutalk@aiub.edu',
      phone: current?.phone ?? '01916147408',
      birthDate: current?.birthDate,
      profileImageUrl: photoUrl ?? current?.profileImageUrl,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.authUserKey, updated.toRawJson());
    return updated;
  }
}

