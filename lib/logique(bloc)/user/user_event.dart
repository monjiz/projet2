import 'package:auth_firebase/data/models/user.dart';

abstract class UserEvent {}

class LoadUsers extends UserEvent {}

class AddUserEvent extends UserEvent {
  final UserModel user;
  AddUserEvent(this.user);
}

class DeleteUserEvent extends UserEvent {
  final String id;
  DeleteUserEvent(this.id);
}

class UpdateUserRoleEvent extends UserEvent {
  final String id;
  final String role;
  UpdateUserRoleEvent(this.id, this.role);
}
