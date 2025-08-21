import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utilities/validators.dart';
import '../../../data/model/user_model.dart';
import '../../../data/datasources/local/user_storage.dart';

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

class UpdateUserProfile extends AuthEvent {
  final String name;
  final String phone;

  UpdateUserProfile({required this.name, required this.phone});

  @override
  List<Object?> get props => [name, phone];
}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;

  AuthAuthenticated({required this.user});

  // Add null safety checks for convenience getters
  String get userId => user.id;
  String get userName => user.name;
  String get userEmail => user.email;
  String get userPhone => user.phone;

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileUpdated extends AuthState {
  final UserModel user;

  ProfileUpdated({required this.user});

  @override
  List<Object?> get props => [user];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserStorage _userStorage = UserStorage.instance;
  final Uuid _uuid = Uuid();

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      // Validate input
      final emailError = Validators.validateEmail(event.email);
      final passwordError = Validators.validatePassword(event.password);

      if (emailError != null) {
        emit(AuthError(message: emailError));
        return;
      }

      if (passwordError != null) {
        emit(AuthError(message: passwordError));
        return;
      }

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 800));

      // Verify credentials
      final user = await _userStorage.verifyCredentials(event.email, event.password);

      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        // Check if user exists but password is wrong
        final userExists = await _userStorage.userExists(event.email);
        if (userExists) {
          emit(AuthError(message: 'Invalid password. Please try again.'));
        } else {
          emit(AuthError(message: 'No account found with this email. Please sign up first.'));
        }
      }
    } catch (e) {
      emit(AuthError(message: 'Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onSignupRequested(
      SignupRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      // Validate all fields
      final validationErrors = Validators.validateSignupForm(
        name: event.name,
        email: event.email,
        password: event.password,
        confirmPassword: event.password, // For now, assuming password is confirmed in UI
        phone: event.phone,
      );

      // Check for validation errors
      final errors = validationErrors.values.where((error) => error != null).toList();
      if (errors.isNotEmpty) {
        emit(AuthError(message: errors.first!));
        return;
      }

      // Check if user already exists
      final userExists = await _userStorage.userExists(event.email);
      if (userExists) {
        emit(AuthError(message: 'An account with this email already exists. Please login instead.'));
        return;
      }

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 1000));

      // Create new user
      final user = UserModel(
        id: _uuid.v4(),
        name: event.name.trim(),
        email: event.email.trim().toLowerCase(),
        phone: event.phone.trim(),
      );

      // Save user data
      await _userStorage.saveUser(user, event.password);

      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: 'Signup failed: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      await _userStorage.clearUserData();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Logout failed: ${e.toString()}'));
    }
  }

  Future<void> _onAuthStatusChecked(
      AuthStatusChecked event,
      Emitter<AuthState> emit,
      ) async {
    try {
      final isLoggedIn = await _userStorage.isLoggedIn();

      if (isLoggedIn) {
        final user = await _userStorage.getCurrentUser();
        if (user != null) {
          emit(AuthAuthenticated(user: user)); // Make sure user is not null
        } else {
          // User data corrupted, force logout
          await _userStorage.clearUserData();
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      // On any error, default to unauthenticated
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfile event,
      Emitter<AuthState> emit,
      ) async {
    if (state is AuthAuthenticated) {
      final currentState = state as AuthAuthenticated;

      try {
        // Validate input
        final nameError = Validators.validateName(event.name);
        final phoneError = Validators.validatePhone(event.phone);

        if (nameError != null) {
          emit(AuthError(message: nameError));
          return;
        }

        if (phoneError != null) {
          emit(AuthError(message: phoneError));
          return;
        }

        // Update user data
        final updatedUser = currentState.user.copyWith(
          name: event.name.trim(),
          phone: event.phone.trim(),
        );

        await _userStorage.updateUser(updatedUser);

        emit(ProfileUpdated(user: updatedUser));
        emit(AuthAuthenticated(user: updatedUser));
      } catch (e) {
        emit(AuthError(message: 'Profile update failed: ${e.toString()}'));
        emit(AuthAuthenticated(user: currentState.user)); // Restore previous state
      }
    }
  }
}
