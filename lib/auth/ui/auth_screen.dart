import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/auth/bloc/auth_cubit.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  void login(BuildContext context) {
    if (nameController.text.trim().isNotEmpty) {
      context.read<AuthCubit>().login(name: nameController.text.trim());
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: nameController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    onPressed:
                        value.text.trim().isNotEmpty
                            ? () => login(context)
                            : null,
                    child: Text('Войти'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
