import 'package:auth_firebase/data/models/annonce_models.dart';
import 'package:auth_firebase/data/models/projet_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'client_event.dart';
import 'client_state.dart';

import '../../../data/models/client_model.dart';
import '../../../data/models/message_model.dart';

import '../../../data/models/worker_model.dart';
import '../../../data/repositories/client_repository.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final ClientRepository clientRepository;

  ClientBloc({required this.clientRepository}) : super(ClientInitial()) {
    on<LoadClientDashboard>((event, emit) async {
      emit(ClientLoading());
      try {
        final List<ClientModel> workers = await clientRepository.fetchTopWorkers();
        emit(ClientLoaded(topWorkers: workers));
      } catch (e) {
        emit(ClientError("Échec de chargement du tableau de bord"));
      }
    });

    on<LoadAnnonces>((event, emit) async {
      emit(ClientLoading());
      try {
        final List<Annonce> annonces = await clientRepository.fetchAnnonces();
        emit(AnnoncesLoaded(annonces));
      } catch (e) {
        emit(ClientError("Échec de chargement des annonces"));
      }
    });

    on<LoadMessages>((event, emit) async {
      emit(ClientLoading());
      try {
        final List<Message> messages = await clientRepository.fetchMessages();
        emit(MessagesLoaded(messages));
      } catch (e) {
        emit(ClientError("Échec de chargement des messages"));
      }
    });

    on<LoadProjects>((event, emit) async {
      emit(ClientLoading());
      try {
        final List<Projet> projects = await clientRepository.fetchProjects();
        emit(ProjectsLoaded(projects));
      } catch (e) {
        emit(ClientError("Échec de chargement des projets"));
      }
    });

    on<LoadWorkers>((event, emit) async {
      emit(ClientLoading());
      try {
        final List<Worker> workers = await clientRepository.fetchWorkers();
        emit(WorkersLoaded(workers));
      } catch (e) {
        emit(ClientError("Échec de chargement des travailleurs"));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await clientRepository.logout();
      emit(ClientInitial());
    });

    on<ShowSnackBar>((event, emit) {
      emit(ClientShowSnack(event.message));
    });
  }
}