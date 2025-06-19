import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_firebase/data/models/annonce_models.dart';
import 'package:auth_firebase/data/repositories/annonce_repository.dart';
import 'annonce_event.dart';
import 'annonce_state.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final AnnouncementRepository repository;

  AnnouncementBloc({required this.repository}) : super(AnnouncementInitial()) {
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

    on<AddAnnouncement>((event, emit) async {
      emit(AnnouncementLoading());
      try {
        await repository.addAnnouncement(event.annonce);
        emit(const AnnouncementOperationSuccess('Annonce ajoutée avec succès'));
        add(LoadAnnouncements());  // Recharge la liste
      } catch (e) {
        emit(AnnouncementError(_mapErrorToMessage(e)));
      }
    });

    on<EditAnnouncement>((event, emit) async {
      emit(AnnouncementLoading());
      try {
        await repository.editAnnouncement(event.id, event.annonce);
        emit(const AnnouncementOperationSuccess('Annonce modifiée avec succès'));
        add(LoadAnnouncements());  // Recharge la liste
      } catch (e) {
        emit(AnnouncementError(_mapErrorToMessage(e)));
      }
    });

    on<DeleteAnnouncement>((event, emit) async {
      emit(AnnouncementLoading());
      try {
        await repository.deleteAnnouncement(event.id);
        emit(const AnnouncementOperationSuccess('Annonce supprimée avec succès'));
        add(LoadAnnouncements());  // Recharge la liste
      } catch (e) {
        emit(AnnouncementError(_mapErrorToMessage(e)));
      }
    });
  }

  String _mapErrorToMessage(Object error) {
    return error.toString();
  }
}
