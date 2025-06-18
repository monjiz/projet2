import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auth_firebase/data/models/annonce_models.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementRepository {
  final String baseUrl = 'https://api.platform.dat.tn/api/v1';

  // ✅ Récupérer le token stocké
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) throw Exception('Token d\'authentification manquant');
    return token;
  }

  // ✅ Récupérer toutes les annonces
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
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded['data'];
        return data.map((e) => Annonce.fromJson(e)).toList();
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erreur lors du chargement des annonces');
      }
    } on SocketException {
      throw Exception('Problème de connexion Internet');
    } catch (e) {
      throw Exception('Erreur fetchAnnouncements : $e');
    }
  }

  // ✅ Ajouter une annonce
  Future<void> addAnnouncement(Annonce annonce) async {
    final token = await _getToken();

    final payload = {
      'title': annonce.title,
      'content': annonce.content,
      'type': annonce.type,
       'publishedAt': annonce.publishedAt, // ✅ Ajouter ici

    };

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

    if (response.statusCode != 201) {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Erreur lors de l\'ajout');
    }
  }
Future<void> editAnnouncement(String id, Annonce annonce) async {
  final token = await _getToken();

  final payload = {
    'title': annonce.title,
    'content': annonce.content,
    'type': annonce.type,
    'publishedAt': DateTime.parse(annonce.publishedAt).toUtc().toIso8601String(),
  };

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

  if (response.statusCode != 200) {
    final error = json.decode(response.body);
    throw Exception(error['message'] ?? 'Erreur lors de la modification');
  }
}

  // ✅ Supprimer une annonce
  Future<void> deleteAnnouncement(String id) async {
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
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Erreur lors de la suppression');
    }
  }
}
