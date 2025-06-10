
import 'package:auth_firebase/data/models/annonce_models.dart';
import 'package:auth_firebase/data/models/client_model.dart';
import 'package:auth_firebase/data/models/message_model.dart';
import 'package:auth_firebase/data/models/projet_models.dart';
import 'package:auth_firebase/data/models/worker_model.dart';

class ClientRepository {
  Future<List<ClientModel>> fetchTopWorkers() async {
    // Simulation de données
    await Future.delayed(const Duration(seconds: 1));
    return [
      ClientModel(id: "1", name: "John Doe", rating: 4.5),
      ClientModel(id: "2", name: "Jane Smith", rating: 4.8),
    ];
  }

  Future<List<Annonce>> fetchAnnonces() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Annonce(
        id: "1",
        titre: "Projet Web",
        contenu: "Création d'un site web",
        datePublication: "2025-06-01",
        type: "Offre",
      ),
      Annonce(
        id: "2",
        titre: "Application Mobile",
        contenu: "Développement d'une app",
        datePublication: "2025-06-02",
        type: "Demande",
      ),
    ];
  }

  Future<List<Message>> fetchMessages() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Message(
        id: "1",
        titre: "Proposition",
        contenu: "Je peux aider avec votre projet",
        destinataire: "John Doe",
        date: "2025-06-02",
      ),
      Message(
        id: "2",
        titre: "Demande de détails",
        contenu: "Pouvez-vous préciser ?",
        destinataire: "Jane Smith",
        date: "2025-06-02",
      ),
    ];
  }

  Future<List<Projet>> fetchProjects() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Projet(
        id: "1",
        titre: "Site E-commerce",
        description: "Développement d'un site de vente",
        status: "En cours",
      ),
      Projet(
        id: "2",
        titre: "App de Gestion",
        description: "Application de gestion interne",
        status: "Terminé",
      ),
    ];
  }

  Future<List<Worker>> fetchWorkers() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Worker(id: "1", name: "John Doe", rating: 4.5, specialty: "Développeur Web"),
      Worker(id: "2", name: "Jane Smith", rating: 4.8, specialty: "Designer UX"),
    ];
  }

  Future<void> logout() async {
    // Simulation de déconnexion
    await Future.delayed(const Duration(seconds: 1));
  }
}