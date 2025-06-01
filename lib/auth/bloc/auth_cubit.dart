import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/auth/data/auth_repository.dart';
import 'package:paint_app/auth/data/user.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit({required this.repository}) : super(const AuthState$Loading());

  void init() {
    emit(const AuthState$Login());
  }

  Future<void> login({required String login, required String password}) async {
    try {
      final user = await repository.login(login: login, password: password);
      emit(AuthState$Authed(user: user));
    } catch (e) {
      emit(const AuthState$Error());
    }
  }

  Future<void> register({
    required String login,
    required String password,
    required String username,
  }) async {
    try {
      final user = await repository.register(
        login: login,
        password: password,
        username: username,
      );
      emit(AuthState$Authed(user: user));
    } catch (e) {
      emit(const AuthState$Error());
    }
  }

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

class AuthState$Error extends AuthState {
  const AuthState$Error();
}

class AuthState$Authed extends AuthState {
  final User user;

  const AuthState$Authed({required this.user});
}
