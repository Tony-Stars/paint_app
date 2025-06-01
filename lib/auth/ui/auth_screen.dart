import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/auth/bloc/auth_cubit.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final isLogin = ValueNotifier(true);

  final usernameController = TextEditingController();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  void login(
    BuildContext context, {
    required String login,
    required String password,
  }) {
    context.read<AuthCubit>().login(
      login: login.trim(),
      password: password.trim(),
    );
  }

  void register(
    BuildContext context, {
    required String login,
    required String password,
    required String username,
  }) {
    context.read<AuthCubit>().register(
      login: login.trim(),
      password: password.trim(),
      username: username.trim(),
    );
  }

  bool canLogin({required String login, required String password}) =>
      login.trim().isNotEmpty && password.trim().isNotEmpty;

  bool canRegister({
    required String login,
    required String password,
    required String username,
  }) =>
      login.trim().isNotEmpty &&
      password.trim().isNotEmpty &&
      username.trim().isNotEmpty;

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    isLogin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: ValueListenableBuilder(
            valueListenable: isLogin,
            builder: (context, value, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: loginController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Логин'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Пароль'),
                      ),
                    ),
                  ),
                  if (!value)
                    Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Имя пользователя'),
                        ),
                      ),
                    ),
                  ListenableBuilder(
                    listenable: Listenable.merge([
                      loginController,
                      passwordController,
                      usernameController,
                    ]),
                    builder: (context, child) {
                      return Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  value
                                      ? canLogin(
                                            login: loginController.text,
                                            password: passwordController.text,
                                          )
                                          ? () => login(
                                            context,
                                            login: loginController.text,
                                            password: passwordController.text,
                                          )
                                          : null
                                      : () {
                                        isLogin.value = true;
                                      },
                              child: Text('Войти'),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  !value
                                      ? canRegister(
                                            login: loginController.text,
                                            password: passwordController.text,
                                            username: usernameController.text,
                                          )
                                          ? () => register(
                                            context,
                                            login: loginController.text,
                                            password: passwordController.text,
                                            username: usernameController.text,
                                          )
                                          : null
                                      : () {
                                        isLogin.value = false;
                                      },
                              child: Text('Зарегистрироваться'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
