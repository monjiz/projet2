// logique(bloc)/projet/projet_event.dart

import '../../data/models/projet_models.dart';
import 'package:equatable/equatable.dart';

abstract class ProjectEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProjectsEvent extends ProjectEvent {}

class AddProjectEvent extends ProjectEvent {
  final ProjectModel project;
  AddProjectEvent(this.project);

  @override
  List<Object?> get props => [project];
}

class UpdateProjectEvent extends ProjectEvent {
  final ProjectModel project;
  UpdateProjectEvent(this.project);

  @override
  List<Object?> get props => [project];
}

class DeleteProjectEvent extends ProjectEvent {
  final String projectId;
  DeleteProjectEvent(this.projectId);

  @override
  List<Object?> get props => [projectId];
}
