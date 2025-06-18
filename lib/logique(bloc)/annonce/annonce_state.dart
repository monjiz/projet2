import 'package:equatable/equatable.dart';
import 'package:auth_firebase/data/models/annonce_models.dart';

abstract class AnnouncementState extends Equatable {
  const AnnouncementState();

  @override
  List<Object?> get props => [];
}

class AnnouncementInitial extends AnnouncementState {}

class AnnouncementLoading extends AnnouncementState {}

class AnnouncementLoaded extends AnnouncementState {
  final List<Annonce> annonces;
  const AnnouncementLoaded(this.annonces);

  @override
  List<Object?> get props => [annonces];
}

class AnnouncementEmpty extends AnnouncementState {}

class AnnouncementError extends AnnouncementState {
  final String message;
  const AnnouncementError(this.message);

  @override
  List<Object?> get props => [message];
}

class AnnouncementOperationSuccess extends AnnouncementState {
  final String message;
  const AnnouncementOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}