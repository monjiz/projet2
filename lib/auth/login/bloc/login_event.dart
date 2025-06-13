
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class GoogleSignInSubmitted extends LoginEvent {
  final BuildContext context;

  const GoogleSignInSubmitted({required this.context});

  @override
  List<Object?> get props => [context];
}

class CheckCurrentUser extends LoginEvent {}
class SignOutRequested extends LoginEvent {}