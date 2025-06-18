import 'package:auth_firebase/data/models/user.dart';
import 'package:auth_firebase/data/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        emit(UserError('Erreur lors du chargement des utilisateurs : ${e.toString()}'));
      }
    });



    

   on<AddUserEvent>((event, emit) async {
  try {
    // NE PAS émettre UserLoading ici
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      emit(UserError("Utilisateur non authentifié"));
      return;
    }

    await repository.addUser(event.user, token);

    // Mettre à jour l'état localement sans rechargement API
    if (state is UserLoaded) {
      final updatedUsers = List<UserModel>.from((state as UserLoaded).users)
        ..add(event.user); // Ajout direct du nouvel user
      emit(UserLoaded(updatedUsers)); // Émission du nouvel état
    }

    // Recharger pour synchroniser avec le backend (optionnel mais recommandé)
    add(LoadUsers());
    
  } catch (e) {
    emit(UserError('Erreur ajout: ${e.toString()}'));
  }
});

    on<DeleteUserEvent>((event, emit) async {
      try {
        await repository.deleteUser(event.id);
        add(LoadUsers());
      } catch (e) {
        emit(UserError('Erreur lors de la suppression de l\'utilisateur : ${e.toString()}'));
      }
    });

    on<UpdateUserRoleEvent>((event, emit) async {
      try {
        await repository.updateUserRole(event.id, event.role);
        add(LoadUsers());
      } catch (e) {
        emit(UserError('Erreur lors de la mise à jour du rôle : ${e.toString()}'));
      }
    });
  }
}
