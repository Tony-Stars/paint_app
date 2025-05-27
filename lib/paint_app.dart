import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/auth/bloc/auth_cubit.dart';
import 'package:paint_app/auth/ui/auth_screen.dart';
import 'package:paint_app/chat/bloc/chat_cubit.dart';
import 'package:paint_app/chat/data/chat_repository.dart';
import 'package:paint_app/common/consts.dart';
import 'package:paint_app/home_screen.dart';

class PaintApp extends StatelessWidget {
  const PaintApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ChatRepository(
      sessionId: sessionId,
      uri: Uri.parse('ws://localhost:5001/'),
    );

    return BlocProvider(
      create: (context) => AuthCubit()..init(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return switch (state) {
            AuthState$Loading _ => MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
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
