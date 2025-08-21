import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? password; // For demo purposes - in real app, never store plain passwords

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.password,
  });

  @override
  List<Object?> get props => [id, name, email, phone];

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }
}
