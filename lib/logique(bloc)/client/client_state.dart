import 'package:auth_firebase/data/models/annonce_models.dart';
import 'package:auth_firebase/data/models/projet_models.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/client_model.dart';
import '../../../data/models/message_model.dart';

import '../../../data/models/worker_model.dart';

abstract class ClientState extends Equatable {
  const ClientState();

  @override
  List<Object?> get props => [];
}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState {}

class ClientLoaded extends ClientState {
  final List<ClientModel> topWorkers;
  const ClientLoaded({required this.topWorkers});

  @override
  List<Object?> get props => [topWorkers];
}

class AnnoncesLoaded extends ClientState {
  final List<Annonce> annonces;
  const AnnoncesLoaded(this.annonces);

  @override
  List<Object?> get props => [annonces];
}

class MessagesLoaded extends ClientState {
  final List<Message> messages;
  const MessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ProjectsLoaded extends ClientState {
  final List<Projet> projects;
  const ProjectsLoaded(this.projects);

  @override
  List<Object?> get props => [projects];
}

class WorkersLoaded extends ClientState {
  final List<Worker> workers;
  const WorkersLoaded(this.workers);

  @override
  List<Object?> get props => [workers];
}

class ClientError extends ClientState {
  final String message;
  const ClientError(this.message);

  @override
  List<Object?> get props => [message];
}

class ClientShowSnack extends ClientState {
  final String message;
  const ClientShowSnack(this.message);

  @override
  List<Object?> get props => [message];
}