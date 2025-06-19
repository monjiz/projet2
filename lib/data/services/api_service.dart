import 'dart:convert';
import 'dart:io'; // Pour gérer les erreurs réseau
import 'package:http/http.dart' as http;
import 'package:auth_firebase/data/models/annonce_models.dart';
import 'package:auth_firebase/data/models/message_model.dart';
import 'package:auth_firebase/data/models/projet_models.dart';
import 'package:auth_firebase/data/models/worker_model.dart';

class ApiService {
  final String baseUrl;
  final String? authToken; // Jeton d'authentification optionnel

  ApiService({
    this.baseUrl = 'https://api.platform.dat.tn/api/v1', // URL alignée avec ClientScreen
    this.authToken,
  });

  // En-têtes communs pour toutes les requêtes
  Map<String, String> _buildHeaders() {
    final headers = {'Content-Type': 'application/json'};
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  /// Récupère toutes les annonces
  Future<List<Annonce>> fetchAnnonces() async {
    try {
      final url = Uri.parse('$baseUrl/annonces');
      final response = await http.get(url, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map<Annonce>((json) => Annonce.fromJson(json)).toList();
        } else {
          throw Exception('Format de données inattendu : la réponse n\'est pas une liste');
        }
      } else {
        throw Exception('Erreur ${response.statusCode} : Impossible de charger les annonces - ${response.body}');
      }
    } on SocketException {
      throw Exception('Erreur réseau : Vérifiez votre connexion Internet');
    } on FormatException {
      throw Exception('Erreur de format : Réponse JSON invalide');
    } catch (e) {
      throw Exception('Erreur inattendue lors du chargement des annonces : $e');
    }
  }

  /// Ajoute une nouvelle annonce
  Future<void> addAnnonce(Annonce annonce) async {
    try {
      final url = Uri.parse('$baseUrl/annonces');
      final response = await http.post(
        url,
        headers: _buildHeaders(),
        body: jsonEncode(annonce.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Erreur ${response.statusCode} : Impossible d\'ajouter l\'annonce - ${response.body}');
      }
    } on SocketException {
      throw Exception('Erreur réseau : Vérifiez votre connexion Internet');
    } catch (e) {
      throw Exception('Erreur inattendue lors de l\'ajout de l\'annonce : $e');
    }
  }

  /// Met à jour une annonce existante identifiée par son id
  Future<void> updateAnnonce(String id, Annonce updated) async {
    try {
      final url = Uri.parse('$baseUrl/annonces/$id');
      final response = await http.put(
        url,
        headers: _buildHeaders(),
        body: jsonEncode(updated.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur ${response.statusCode} : Impossible de mettre à jour l\'annonce - ${response.body}');
      }
    } on SocketException {
      throw Exception('Erreur réseau : Vérifiez votre connexion Internet');
    } catch (e) {
      throw Exception('Erreur inattendue lors de la mise à jour de l\'annonce : $e');
    }
  }

  /// Supprime une annonce identifiée par son id
  Future<void> deleteAnnonce(String id) async {
    try {
      final url = Uri.parse('$baseUrl/annonces/$id');
      final response = await http.delete(url, headers: _buildHeaders());

      if (response.statusCode != 200) {
        throw Exception('Erreur ${response.statusCode} : Impossible de supprimer l\'annonce - ${response.body}');
      }
    } on SocketException {
      throw Exception('Erreur réseau : Vérifiez votre connexion Internet');
    } catch (e) {
      throw Exception('Erreur inattendue lors de la suppression de l\'annonce : $e');
    }
  }

  /// Récupère tous les messages
  Future<List<Message>> fetchMessages() async {
    try {
      final url = Uri.parse('$baseUrl/messages');
      final response = await http.get(url, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map<Message>((json) => Message.fromJson(json)).toList();
        } else {
          throw Exception('Format de données inattendu : la réponse n\'est pas une liste');
        }
      } else {
        throw Exception('Erreur ${response.statusCode} : Impossible de charger les messages - ${response.body}');
      }
    } on SocketException {
      throw Exception('Erreur réseau : Vérifiez votre connexion Internet');
    } on FormatException {
      throw Exception('Erreur de format : Réponse JSON invalide');
    } catch (e) {
      throw Exception('Erreur inattendue lors du chargement des messages : $e');
    }
  }

  /// Récupère tous les projets
  Future<List<ProjectModel>> fetchProjects() async {
    try {
      final url = Uri.parse('$baseUrl/projects');
      final response = await http.get(url, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map<ProjectModel>((json) => ProjectModel.fromJson(json)).toList();
        } else {
          throw Exception('Format de données inattendu : la réponse n\'est pas une liste');
        }
      } else {
        throw Exception('Erreur ${response.statusCode} : Impossible de charger les projets - ${response.body}');
      }
    } on SocketException {
      throw Exception('Erreur réseau : Vérifiez votre connexion Internet');
    } on FormatException {
      throw Exception('Erreur de format : Réponse JSON invalide');
    } catch (e) {
      throw Exception('Erreur inattendue lors du chargement des projets : $e');
    }
  }

  /// Récupère tous les travailleurs
  Future<List<Worker>> fetchWorkers() async {
    try {
      final url = Uri.parse('$baseUrl/workers');
      final response = await http.get(url, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map<Worker>((json) => Worker.fromJson(json)).toList();
        } else {
          throw Exception('Format de données inattendu : la réponse n\'est pas une liste');
        }
      } else {
        throw Exception('Erreur ${response.statusCode} : Impossible de charger les travailleurs - ${response.body}');
      }
    } on SocketException {
      throw Exception('Erreur réseau : Vérifiez votre connexion Internet');
    } on FormatException {
      throw Exception('Erreur de format : Réponse JSON invalide');
    } catch (e) {
      throw Exception('Erreur inattendue lors du chargement des travailleurs : $e');
    }
  }

  /// Récupère les top travailleurs (similaire à fetchWorkers mais avec un tri ou une limite)
  Future<List<Worker>> fetchTopWorkers() async {
    try {
      final url = Uri.parse('$baseUrl/workers?top=true'); // Exemple avec un paramètre pour les top travailleurs
      final response = await http.get(url, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map<Worker>((json) => Worker.fromJson(json)).toList();
        } else {
          throw Exception('Format de données inattendu : la réponse n\'est pas une liste');
        }
      } else {
        throw Exception('Erreur ${response.statusCode} : Impossible de charger les top travailleurs - ${response.body}');
      }
    } on SocketException {
      throw Exception('Erreur réseau : Vérifiez votre connexion Internet');
    } on FormatException {
      throw Exception('Erreur de format : Réponse JSON invalide');
    } catch (e) {
      throw Exception('Erreur inattendue lors du chargement des top travailleurs : $e');
    }
  }
}