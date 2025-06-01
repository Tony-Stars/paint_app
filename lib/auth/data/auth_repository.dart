import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:paint_app/auth/data/user.dart';
import 'package:paint_app/common/api_client.dart';

class AuthRepository {
  final ApiClient client;

  const AuthRepository({required this.client});

  Future<User> login({required String login, required String password}) async {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    final response = await client.post(
      '/login',
      data: <String, dynamic>{'login': login, 'password': digest.toString()},
    );

    return User.fromJson(response.data);
  }

  Future<User> register({
    required String login,
    required String password,
    required String username,
  }) async {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    final response = await client.post(
      '/register',
      data: <String, dynamic>{
        'login': login,
        'password': digest.toString(),
        'username': username,
      },
    );

    return User.fromJson(response.data);
  }
}
