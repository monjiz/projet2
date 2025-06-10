import 'package:auth_firebase/data/models/role_models.dart';

abstract class RolePermissionEvent {
  const RolePermissionEvent();
}

class CreateRole extends RolePermissionEvent {
  final Role role;

  const CreateRole(this.role);

  void validate() {
    if (role.name.trim().isEmpty) {
      throw Exception('Le nom du rôle est requis');
    }
  }
}

class AssignPermissionsToRole extends RolePermissionEvent {
  final String roleId;
  final List<String> permissions;

  const AssignPermissionsToRole(this.roleId, this.permissions);

  void validate() {
    if (roleId.trim().isEmpty) {
      throw Exception('L’ID du rôle est requis');
    }
    if (permissions.isEmpty) {
      throw Exception('Au moins une permission est requise');
    }
  }
}

class AssignRoleToUser extends RolePermissionEvent {
  final String userId;
  final String roleId;

  const AssignRoleToUser(this.userId, this.roleId);

  void validate() {
    if (userId.trim().isEmpty) {
      throw Exception('L’ID de l’utilisateur est requis');
    }
    if (roleId.trim().isEmpty) {
      throw Exception('L’ID du rôle est requis');
    }
  }
}

class LoadRolesAndPermissions extends RolePermissionEvent {
  const LoadRolesAndPermissions();
}

class UpdateRole extends RolePermissionEvent {
  final Role role;

  const UpdateRole(this.role);

  void validate() {
    if (role.id.trim().isEmpty) {
      throw Exception('L’ID du rôle est requis pour la mise à jour');
    }
    if (role.name.trim().isEmpty) {
      throw Exception('Le nom du rôle est requis pour la mise à jour');
    }
  }
}

class DeleteRole extends RolePermissionEvent {
  final String roleId;

  const DeleteRole(this.roleId);

  void validate() {
    if (roleId.trim().isEmpty) {
      throw Exception('L’ID du rôle est requis pour la suppression');
    }
  }
}