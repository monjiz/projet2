import 'package:auth_firebase/data/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
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
    emit(UserLoading());

    // Récupérer le token depuis SharedPreferences (car tu utilises ton backend, pas Firebase Auth)
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    print("DEBUG: token récupéré = $token");

    if (token == null || token.isEmpty) {
      print("DEBUG ERROR: token est null ou vide");
      emit(UserError("Utilisateur non authentifié (token manquant)"));
      return;
    }

    await repository.addUser(event.user, token);
    print("DEBUG: utilisateur ajouté avec succès");

    add(LoadUsers());
  } catch (e, stackTrace) {
    print("DEBUG ERROR: exception dans AddUserEvent: $e");
    print("STACK TRACE:\n$stackTrace");
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
