import 'package:equatable/equatable.dart';

abstract class ClientEvent extends Equatable {
  const ClientEvent();

  @override
  List<Object?> get props => [];
}

class LoadClientDashboard extends ClientEvent {}

class LoadAnnonces extends ClientEvent {}

class LoadMessages extends ClientEvent {}

class LoadProjects extends ClientEvent {}

class LoadWorkers extends ClientEvent {}

class LogoutRequested extends ClientEvent {}

class ShowSnackBar extends ClientEvent {
  final String message;
  const ShowSnackBar(this.message);

  @override
  List<Object?> get props => [message];
}