import 'dart:convert';
import 'package:auth_firebase/data/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final String baseUrl = 'https://api.platform.dat.tn/api/v1';

  // 🔐 Récupérer le token stocké
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) throw Exception('Token d\'authentification manquant');
    return token;
  }

  // 🔹 Récupérer tous les utilisateurs
  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['data'] == null) {
        throw Exception('La clé "data" est absente ou null dans la réponse');
      }

      final List<dynamic> usersList = jsonData['data'];
      return usersList.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des utilisateurs');
    }
  }

  // 🔹 Ajouter un utilisateur
  Future<void> addUser(UserModel user, String token) async {
    final url = Uri.parse('$baseUrl/users/user');

    final body = jsonEncode(user.toJson());
    print("DEBUG: Requête POST vers $url");
    print("DEBUG: Corps JSON = $body");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    print("DEBUG: Status code = ${response.statusCode}");
    print("DEBUG: Corps réponse = ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      String errorMessage = "Erreur lors de l’ajout utilisateur";
      try {
        final errorJson = jsonDecode(response.body);
        if (errorJson['message'] != null) {
          errorMessage = errorJson['message'];
        } else if (errorJson['error'] != null) {
          errorMessage = errorJson['error'];
        }
      } catch (_) {}
      throw Exception('$errorMessage (status ${response.statusCode})');
    }
  }

  // 🔹 Supprimer un utilisateur
  Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression');
    }
  }

  // 🔹 Modifier le rôle d'un utilisateur
  Future<void> updateUserRole(String id, String newRole) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'role': newRole}),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la modification');
    }
  }

  // 🔹 Récupérer uniquement les workers
  Future<List<UserModel>> fetchWorkers() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users/workers'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('DEBUG: Workers response = ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['data'] == null) {
        throw Exception('La clé "data" est absente ou null dans la réponse');
      }

      final List<dynamic> workersList = jsonData['data'];
      return workersList.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Échec de la récupération des workers (${response.statusCode})');
    }
  }
}
