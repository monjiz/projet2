// logique(bloc)/projet/projet_state.dart
import '../../data/models/projet_models.dart';
import 'package:equatable/equatable.dart';

abstract class ProjectState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class ProjectLoaded extends ProjectState {
  final List<ProjectModel> projects;
  ProjectLoaded(this.projects);

  @override
  List<Object?> get props => [projects];
}

class ProjectSuccess extends ProjectState {
  final String message;
  ProjectSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ProjectFailure extends ProjectState {
  final String error;
  ProjectFailure(this.error);

  @override
  List<Object?> get props => [error];
}
