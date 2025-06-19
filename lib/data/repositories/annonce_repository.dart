import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auth_firebase/data/models/annonce_models.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementRepository {
  final String baseUrl = 'https://api.platform.dat.tn/api/v1';

  // Récupérer le token stocké
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) throw Exception('Token d\'authentification manquant');
    return token;
  }

  // Récupérer toutes les annonces
  Future<List<Annonce>> fetchAnnouncements() async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/announcements'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log('Status: ${response.statusCode}');
      log('Body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        
        // Correction 1: Vérification plus robuste de la structure de réponse
        if (decoded.containsKey('data') && decoded['data'] is List) {
          final List<dynamic> data = decoded['data'];
          return data.map((e) => Annonce.fromJson(e)).toList();
        } else {
          throw Exception('Structure de réponse invalide');
        }
      } else {
        // Correction 2: Meilleure gestion des erreurs
        final errorMessage = _parseErrorMessage(response.body);
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Problème de connexion Internet');
    } on http.ClientException {
      throw Exception('Erreur de connexion au serveur');
    } catch (e) {
      throw Exception('Erreur fetchAnnouncements : ${e.toString()}');
    }
  }

  // Ajouter une annonce
  Future<Annonce> addAnnouncement(Annonce annonce) async { // Correction 3: Retourne l'annonce créée
    try {
      final token = await _getToken();

      final payload = {
        'title': annonce.title,
        'content': annonce.content,
        'type': annonce.type,
        'publishedAt': annonce.publishedAt, // format ISO
      };

      log('Add payload: ${json.encode(payload)}'); // Log avant envoi

      final response = await http.post(
        Uri.parse('$baseUrl/announcements'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(payload),
      );

      log('Add response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201) {
        // Correction 4: Retourner l'annonce créée
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        return Annonce.fromJson(responseData['data']);
      } else {
        final errorMessage = _parseErrorMessage(response.body);
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Problème de connexion Internet');
    } catch (e) {
      throw Exception('Erreur addAnnouncement: ${e.toString()}');
    }
  }

  // Modifier une annonce
  Future<Annonce> editAnnouncement(String id, Annonce annonce) async { // Correction 5: Retourne l'annonce modifiée
    try {
      final token = await _getToken();

      final payload = {
        'title': annonce.title,
        'content': annonce.content,
        'type': annonce.type,
        'publishedAt': annonce.publishedAt,
      };

      log('Edit payload: ${json.encode(payload)}');

      final response = await http.patch(
        Uri.parse('$baseUrl/announcements/$id'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(payload),
      );

      log('Edit response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        // Correction 6: Retourner l'annonce mise à jour
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        return Annonce.fromJson(responseData['data']);
      } else {
        final errorMessage = _parseErrorMessage(response.body);
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Problème de connexion Internet');
    } catch (e) {
      throw Exception('Erreur editAnnouncement: ${e.toString()}');
    }
  }

  // Supprimer une annonce
  Future<void> deleteAnnouncement(String id) async {
    try {
      final token = await _getToken();

      final response = await http.delete(
        Uri.parse('$baseUrl/announcements/$id'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log('Delete response: ${response.statusCode} - ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        final errorMessage = _parseErrorMessage(response.body);
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Problème de connexion Internet');
    } catch (e) {
      throw Exception('Erreur deleteAnnouncement: ${e.toString()}');
    }
  }

  // Correction 7: Fonction utilitaire pour parser les messages d'erreur
  String _parseErrorMessage(String responseBody) {
    try {
      final errorJson = json.decode(responseBody) as Map<String, dynamic>;
      return errorJson['message'] ?? 
             errorJson['error'] ??
             'Erreur inconnue (${responseBody.length > 100 ? responseBody.substring(0, 100) + '...' : responseBody})';
    } catch (e) {
      return 'Erreur inconnue (${responseBody.length > 100 ? responseBody.substring(0, 100) + '...' : responseBody})';
    }
  }
}