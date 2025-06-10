import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_firebase/logique(bloc)/annonce/annonce_event.dart';
import 'package:auth_firebase/logique(bloc)/annonce/annonce_state.dart';
import 'package:auth_firebase/data/services/api_service.dart';
import 'package:auth_firebase/data/models/annonce_models.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final ApiService apiService;

  AnnouncementBloc({
    required this.apiService,
    String? authToken, // Paramètre optionnel pour l'authentification
  }) : super(AnnouncementInitial()) { // Changement d'état initial
    // Chargement des annonces
    on<LoadAnnonces>((event, emit) async {
      emit(AnnouncementLoading());
      try {
        final annonces = await apiService.fetchAnnonces();
        if (annonces.isEmpty) {
          emit(AnnouncementEmpty());
        } else {
          emit(AnnouncementLoaded(annonces));
        }
      } on Exception catch (e) {
        emit(AnnouncementError('Impossible de charger les annonces. Veuillez réessayer.'));
      }
    });

    // Ajout d'une annonce
    on<AddAnnouncement>((event, emit) async {
      emit(AnnouncementLoading());
      try {
        await apiService.addAnnonce(event.announcement);
        final annonces = await apiService.fetchAnnonces();
        if (annonces.isEmpty) {
          emit(AnnouncementEmpty());
        } else {
          emit(AnnouncementLoaded(annonces));
        }
      } on Exception catch (e) {
        emit(AnnouncementError('Impossible d\'ajouter l\'annonce. Veuillez réessayer.'));
      }
    });

    // Modification d'une annonce
    on<EditAnnouncement>((event, emit) async {
      emit(AnnouncementLoading());
      try {
        await apiService.updateAnnonce(event.id, event.updated);
        final annonces = await apiService.fetchAnnonces();
        if (annonces.isEmpty) {
          emit(AnnouncementEmpty());
        } else {
          emit(AnnouncementLoaded(annonces));
        }
      } on Exception catch (e) {
        emit(AnnouncementError('Impossible de modifier l\'annonce. Veuillez réessayer.'));
      }
    });

    // Suppression d'une annonce
    on<DeleteAnnouncement>((event, emit) async {
      emit(AnnouncementLoading());
      try {
        await apiService.deleteAnnonce(event.id);
        final annonces = await apiService.fetchAnnonces();
        if (annonces.isEmpty) {
          emit(AnnouncementEmpty());
        } else {
          emit(AnnouncementLoaded(annonces));
        }
      } on Exception catch (e) {
        emit(AnnouncementError('Impossible de supprimer l\'annonce. Veuillez réessayer.'));
      }
    });
  }
}