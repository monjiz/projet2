import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupSubmitted extends SignupEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String role;

  const SignupSubmitted({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });

  @override
  List<Object?> get props => [name, email, password, confirmPassword, role];
}

class GoogleSignInSubmitted extends SignupEvent {}
// signup_event.dart
class SignupWithGoogle extends SignupEvent {}
