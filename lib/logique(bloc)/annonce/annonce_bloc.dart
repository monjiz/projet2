import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_firebase/data/models/annonce_models.dart';
import 'package:auth_firebase/data/repositories/annonce_repository.dart';
import 'annonce_event.dart';
import 'annonce_state.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final AnnouncementRepository repository;

  AnnouncementBloc({required this.repository}) : super(AnnouncementInitial()) {
    // Charger les annonces
    on<LoadAnnouncements>((event, emit) async {
      emit(AnnouncementLoading());
      try {
        final annonces = await repository.fetchAnnouncements();
        if (annonces.isEmpty) {
          emit(AnnouncementEmpty());
        } else {
          emit(AnnouncementLoaded(annonces));
        }
      } catch (e) {
        emit(AnnouncementError(_mapErrorToMessage(e)));
      }
    });

    // Ajouter une annonce
    on<AddAnnouncement>((event, emit) async {
      emit(AnnouncementLoading());
      try {
        await repository.addAnnouncement(event.annonce);
        emit(const AnnouncementOperationSuccess('Annonce ajoutée avec succès'));
        add(LoadAnnouncements());
      } catch (e) {
        emit(AnnouncementError(_mapErrorToMessage(e)));
      }
    });

    // Modifier une annonce
    on<EditAnnouncement>((event, emit) async {
      emit(AnnouncementLoading());
      try {
        final editedAnnonce = event.annonce.copyWith(
          publishedAt: DateTime.parse(event.annonce.publishedAt)
              .toUtc()
              .toIso8601String(),
        );
        await repository.editAnnouncement(event.id, editedAnnonce);
        emit(const AnnouncementOperationSuccess('Annonce modifiée avec succès'));
        add(LoadAnnouncements());
      } catch (e) {
        emit(AnnouncementError(_mapErrorToMessage(e)));
      }
    });

    // Supprimer une annonce
    on<DeleteAnnouncement>((event, emit) async {
      emit(AnnouncementLoading());
      try {
        await repository.deleteAnnouncement(event.id);
        emit(const AnnouncementOperationSuccess('Annonce supprimée avec succès'));
        add(LoadAnnouncements());
      } catch (e) {
        emit(AnnouncementError(_mapErrorToMessage(e)));
      }
    });
  }

  String _mapErrorToMessage(Object error) {
    // Personnalise selon ton besoin
    return error.toString();
  }
}
