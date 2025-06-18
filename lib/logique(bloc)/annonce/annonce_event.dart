import 'package:equatable/equatable.dart';
import 'package:auth_firebase/data/models/annonce_models.dart';

abstract class AnnouncementEvent extends Equatable {
  const AnnouncementEvent();
  @override
  List<Object?> get props => [];
}

class LoadAnnouncements extends AnnouncementEvent {}

class AddAnnouncement extends AnnouncementEvent {
  final Annonce annonce;
  const AddAnnouncement(this.annonce);

  @override
  List<Object?> get props => [annonce];
}

class EditAnnouncement extends AnnouncementEvent {
  final String id;
  final Annonce annonce;
  const EditAnnouncement(this.id, this.annonce);

  @override
  List<Object?> get props => [id, annonce];
}

class DeleteAnnouncement extends AnnouncementEvent {
  final String id;
  const DeleteAnnouncement(this.id);

  @override
  List<Object?> get props => [id];
}