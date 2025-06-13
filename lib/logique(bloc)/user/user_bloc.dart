import 'package:auth_firebase/data/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserInitial()) {
    on<LoadUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await repository.fetchUsers();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<AddUserEvent>((event, emit) async {
      try {
        await repository.addUser(event.user);
        add(LoadUsers());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<DeleteUserEvent>((event, emit) async {
      try {
        await repository.deleteUser(event.id);
        add(LoadUsers());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<UpdateUserRoleEvent>((event, emit) async {
      try {
        await repository.updateUserRole(event.id, event.role);
        add(LoadUsers());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
