import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/auth/bloc/auth_cubit.dart';
import 'package:paint_app/auth/data/auth_repository.dart';
import 'package:paint_app/auth/ui/auth_screen.dart';
import 'package:paint_app/chat/bloc/chat_cubit.dart';
import 'package:paint_app/chat/data/chat_repository.dart';
import 'package:paint_app/common/api_client.dart';
import 'package:paint_app/common/consts.dart';
import 'package:paint_app/home_screen.dart';

class PaintApp extends StatelessWidget {
  const PaintApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final repository = ChatRepository(
      sessionId: sessionId,
      uri: Uri.parse('ws://localhost:5001/'),
    );

    final authRepository = AuthRepository(client: apiClient);
    return BlocProvider(
      create: (context) => AuthCubit(repository: authRepository)..init(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return switch (state) {
            AuthState$Loading _ => MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            ),
            AuthState$Error _ => MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text('Произошла ошибка'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthCubit>().init();
                        },
                        child: Text('Попробовать ещё раз'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AuthState$Login _ => MaterialApp(home: AuthScreen()),
            AuthState$Authed authed => BlocProvider(
              create:
                  (context) =>
                      ChatCubit(user: authed.user, repository: repository)
                        ..init(),
              child: MaterialApp(
                scrollBehavior: const PaintAppScrollBehavior(),
                initialRoute: '/',
                // routes: {'/auth': (context) => AuthScreen()},
                home: HomeScreen(user: authed.user),
              ),
            ),
          };
        },
      ),
    );
  }
}

class PaintAppScrollBehavior extends MaterialScrollBehavior {
  const PaintAppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
