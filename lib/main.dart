import 'package:demato/presentation/bloc/history/order_history_bloc.dart';
import 'package:demato/presentation/bloc/restaurant/restaurant_list_bloc.dart';
import 'package:demato/presentation/pages/home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/cart/cart_bloc.dart';
import 'presentation/bloc/menu/menu_bloc.dart';
import 'presentation/bloc/order/order_bloc.dart';
import 'presentation/pages/auth/login_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        BlocProvider<CartBloc>(
          create: (context) => CartBloc()..add(LoadCart()),
        ),
        BlocProvider<MenuBloc>(
          create: (context) => MenuBloc(),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => OrderBloc(),
        ),
        BlocProvider<OrderHistoryBloc>(
          create: (context) => OrderHistoryBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Demato',
        theme: ThemeData(
          primarySwatch: Colors.red,
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return HomePage();
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
