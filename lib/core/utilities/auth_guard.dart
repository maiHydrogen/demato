import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/pages/auth/login_page.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  final Widget? loadingWidget;

  const AuthGuard({
    Key? key,
    required this.child,
    this.loadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return child;
        } else if (state is AuthUnauthenticated) {
          return LoginPage();
        } else {
          return loadingWidget ??
              Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.red),
                      SizedBox(height: 16),
                      Text('Loading...'),
                    ],
                  ),
                ),
              );
        }
      },
    );
  }
}
