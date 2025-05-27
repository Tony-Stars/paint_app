import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/auth/data/user.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState$Loading());

  void init() {
    emit(const AuthState$Login());
  }

  void login({required String name}) {
    final rnd = Random();
    final user = User(id: rnd.nextInt(1000000), name: name);
    emit(AuthState$Authed(user: user));
  }

  void register() {}

  void logout() {}
}

sealed class AuthState {
  const AuthState();
}

class AuthState$Login extends AuthState {
  const AuthState$Login();
}

class AuthState$Loading extends AuthState {
  const AuthState$Loading();
}

class AuthState$Authed extends AuthState {
  final User user;

  const AuthState$Authed({required this.user});
}
