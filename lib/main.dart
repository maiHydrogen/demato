import 'package:demato/presentation/bloc/restaurant/restaurant_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/pages/auth/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AuthStatusChecked()),
        ),
        BlocProvider<RestaurantListBloc>(
          create: (context) => RestaurantListBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Mini Zomato',
        theme: ThemeData(
          primarySwatch: Colors.red,
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return Scaffold();
            } else if (state is AuthUnauthenticated) {
              return LoginPage();
            } else {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
