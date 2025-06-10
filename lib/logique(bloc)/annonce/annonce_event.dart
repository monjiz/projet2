import 'package:equatable/equatable.dart';
import 'package:auth_firebase/data/models/annonce_models.dart';

abstract class AnnouncementEvent extends Equatable {
  const AnnouncementEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnnonces extends AnnouncementEvent {}

class AddAnnouncement extends AnnouncementEvent {
  final Annonce announcement;

  const AddAnnouncement(this.announcement);

  @override
  List<Object?> get props => [announcement];
}

class EditAnnouncement extends AnnouncementEvent {
  final String id;
  final Annonce updated;

  const EditAnnouncement(this.id, this.updated);

  @override
  List<Object?> get props => [id, updated];
}

class DeleteAnnouncement extends AnnouncementEvent {
  final String id;

  const DeleteAnnouncement(this.id);

  @override
  List<Object?> get props => [id];
}