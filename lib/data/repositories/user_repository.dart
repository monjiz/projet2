import 'dart:convert';
import 'package:auth_firebase/data/models/user.dart';
import 'package:http/http.dart' as http;


class UserRepository {
  final String baseUrl = 'https://api.platform.dat.tn/api/v1'; // Change selon ton backend

  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des utilisateurs');
    }
  }

  Future<void> addUser(UserModel user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Erreur lors de l\'ajout de l\'utilisateur');
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression');
    }
  }

  Future<void> updateUserRole(String id, String newRole) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'role': newRole}),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la modification');
    }
  }
}
