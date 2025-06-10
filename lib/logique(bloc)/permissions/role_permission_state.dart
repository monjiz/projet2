import 'package:auth_firebase/data/models/role_models.dart';
import 'package:equatable/equatable.dart';

abstract class RolePermissionState extends Equatable {
  const RolePermissionState();

  @override
  List<Object?> get props => [];
}

class RolePermissionInitial extends RolePermissionState {}

class RolePermissionLoading extends RolePermissionState {}

class RolePermissionError extends RolePermissionState {
  final String message;
  const RolePermissionError(this.message);

  @override
  List<Object?> get props => [message];
}

class RolesAndPermissionsLoaded extends RolePermissionState {
  final List<Role> roles;
  final List<String> permissions;
  final bool isRecentlyUpdated;

  const RolesAndPermissionsLoaded(this.roles, this.permissions, {this.isRecentlyUpdated = false});

  @override
  List<Object?> get props => [roles, permissions, isRecentlyUpdated];
}