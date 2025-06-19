// logique(bloc)/projet/projet_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'projet_event.dart';
import 'projet_state.dart';
import '../../data/repositories/projet_repository.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository repository;
  final String token;

  ProjectBloc({required this.repository, required this.token}) : super(ProjectInitial()) {
    on<LoadProjectsEvent>(_onLoadProjects);
    on<AddProjectEvent>(_onAddProject);
    on<UpdateProjectEvent>(_onUpdateProject);
    on<DeleteProjectEvent>(_onDeleteProject);
  }

  Future<void> _onLoadProjects(LoadProjectsEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    try {
      final projects = await repository.fetchProjects(token);
      emit(ProjectLoaded(projects));
    } catch (e) {
      emit(ProjectFailure(e.toString()));
    }
  }

  Future<void> _onAddProject(AddProjectEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    try {
      await repository.addProject(event.project, token);
      add(LoadProjectsEvent());
    } catch (e) {
      emit(ProjectFailure(e.toString()));
    }
  }

  Future<void> _onUpdateProject(UpdateProjectEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    try {
      await repository.updateProject(event.project, token);
      add(LoadProjectsEvent());
    } catch (e) {
      emit(ProjectFailure(e.toString()));
    }
  }

  Future<void> _onDeleteProject(DeleteProjectEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    try {
      await repository.deleteProject(event.projectId, token);
      add(LoadProjectsEvent());
    } catch (e) {
      emit(ProjectFailure(e.toString()));
    }
  }
}
