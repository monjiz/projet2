import 'dart:developer';
import 'package:auth_firebase/data/models/role_models.dart';
import 'package:auth_firebase/data/repositories/role_permission_repository.dart';
import 'package:auth_firebase/logique(bloc)/permissions/role_permission_event.dart';
import 'package:auth_firebase/logique(bloc)/permissions/role_permission_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RolePermissionBloc extends Bloc<RolePermissionEvent, RolePermissionState> {
  final RolePermissionRepository repository;

  RolePermissionBloc(this.repository) : super(RolePermissionInitial()) {
    Future<void> _loadRolesAndPermissions(Emitter<RolePermissionState> emit) async {
      try {
        final roles = await repository.getAllRoles();
        final permissions = await repository.getAllPermissions();
        emit(RolesAndPermissionsLoaded(
          roles.map((r) => Role.fromJson(r)).toList(),
          permissions.cast<String>(),
        ));
      } catch (e) {
        final errorMessage = e.toString().contains('Exception:') ? e.toString().split('Exception: ')[1] : e.toString();
        log("Échec du chargement des données : $errorMessage");
        emit(RolePermissionError('Échec du chargement des données : $errorMessage'));
      }
    }

    on<CreateRole>((event, emit) async {
      emit(RolePermissionLoading());
      try {
        event.validate();
        await repository.createRole(event.role.toJson());
        log("Rôle créé avec succès : ${event.role.name}");
        await _loadRolesAndPermissions(emit);
      } catch (e) {
        final errorMessage = e.toString().contains('Exception:') ? e.toString().split('Exception: ')[1] : e.toString();
        log("Erreur lors de la création du rôle : $errorMessage");
        emit(RolePermissionError('Erreur lors de la création du rôle : $errorMessage'));
      }
    });

    on<AssignPermissionsToRole>((event, emit) async {
      emit(RolePermissionLoading());
      try {
        event.validate();
        await repository.assignPermissions(event.roleId, event.permissions);
        log("Permissions attribuées au rôle : $event.roleId");
        await _loadRolesAndPermissions(emit);
      } catch (e) {
        final errorMessage = e.toString().contains('Exception:') ? e.toString().split('Exception: ')[1] : e.toString();
        log("Erreur lors de l’attribution des permissions : $errorMessage");
        emit(RolePermissionError('Erreur lors de l’attribution des permissions : $errorMessage'));
      }
    });

    on<AssignRoleToUser>((event, emit) async {
      emit(RolePermissionLoading());
      try {
        event.validate();
        await repository.assignRoleToUser(event.userId, event.roleId);
        log("Rôle assigné à l’utilisateur : $event.userId -> $event.roleId");
        await _loadRolesAndPermissions(emit);
      } catch (e) {
        final errorMessage = e.toString().contains('Exception:') ? e.toString().split('Exception: ')[1] : e.toString();
        log("Erreur lors de l’assignation du rôle à l’utilisateur : $errorMessage");
        emit(RolePermissionError('Erreur lors de l’assignation du rôle à l’utilisateur : $errorMessage'));
      }
    });

    on<LoadRolesAndPermissions>((event, emit) async {
      emit(RolePermissionLoading());
      await _loadRolesAndPermissions(emit);
    });

    on<UpdateRole>((event, emit) async {
      emit(RolePermissionLoading());
      try {
        event.validate();
        await repository.updateRole(event.role.toJson());
        log("Rôle mis à jour : ${event.role.id}");
        await _loadRolesAndPermissions(emit);
      } catch (e) {
        final errorMessage = e.toString().contains('Exception:') ? e.toString().split('Exception: ')[1] : e.toString();
        log("Erreur lors de la mise à jour du rôle : $errorMessage");
        emit(RolePermissionError('Erreur lors de la mise à jour du rôle : $errorMessage'));
      }
    });

    on<DeleteRole>((event, emit) async {
      emit(RolePermissionLoading());
      try {
        event.validate();
        await repository.deleteRole(event.roleId);
        log("Rôle supprimé : $event.roleId");
        await _loadRolesAndPermissions(emit);
      } catch (e) {
        final errorMessage = e.toString().contains('Exception:') ? e.toString().split('Exception: ')[1] : e.toString();
        log("Erreur lors de la suppression du rôle : $errorMessage");
        emit(RolePermissionError('Erreur lors de la suppression du rôle : $errorMessage'));
      }
    });
  }
}