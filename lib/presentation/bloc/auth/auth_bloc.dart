import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignupRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;

  SignupRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });

  @override
  List<Object?> get props => [name, email, password, phone];
}

class LogoutRequested extends AuthEvent {}

class AuthStatusChecked extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String userName;

  AuthAuthenticated({required this.userId, required this.userName});

  @override
  List<Object?> get props => [userId, userName];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
  }

  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      // Mock login - in real app, call API
      await Future.delayed(Duration(seconds: 1));

      if (event.email.isNotEmpty && event.password.length >= 6) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', '123');
        await prefs.setString('user_name', 'John Doe');
        await prefs.setBool('is_logged_in', true);

        emit(AuthAuthenticated(userId: '123', userName: 'John Doe'));
      } else {
        emit(AuthError(message: 'Invalid credentials'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignupRequested(
      SignupRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      // Mock signup
      await Future.delayed(Duration(seconds: 1));

      if (event.email.isNotEmpty && event.password.length >= 6) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', '123');
        await prefs.setString('user_name', event.name);
        await prefs.setBool('is_logged_in', true);

        emit(AuthAuthenticated(userId: '123', userName: event.name));
      } else {
        emit(AuthError(message: 'Invalid input data'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthStatusChecked(
      AuthStatusChecked event,
      Emitter<AuthState> emit,
      ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

      if (isLoggedIn) {
        final userId = prefs.getString('user_id') ?? '';
        final userName = prefs.getString('user_name') ?? '';
        emit(AuthAuthenticated(userId: userId, userName: userName));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }
}
