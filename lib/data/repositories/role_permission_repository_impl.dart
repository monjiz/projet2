import 'dart:convert';
import 'dart:developer';
import 'package:auth_firebase/data/repositories/role_permission_repository.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RolePermissionRepositoryImpl implements RolePermissionRepository {
  final String baseUrl = 'https://api.platform.dat.tn/api/v1';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _postRequest(String endpoint, Map<String, dynamic> body) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    log('Requête POST $endpoint : ${response.statusCode} - ${response.body}');
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erreur lors de la requête : ${response.body}');
    }
  }

  Future<Map<String, dynamic>> _getRequest(String endpoint) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    log('Requête GET $endpoint : ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors de la requête : ${response.body}');
    }
  }

  @override
  Future<void> createRole(Map<String, dynamic> role) async {
    try {
      await _postRequest('/roles', role);
    } catch (e) {
      log('Erreur dans createRole : $e');
      throw Exception('Échec de la création du rôle');
    }
  }

  @override
  Future<void> updateRole(Map<String, dynamic> role) async {
    try {
      final roleId = role['id'] as String?;
      if (roleId == null) throw Exception('ID du rôle manquant');
      await _postRequest('/roles/$roleId', role);
    } catch (e) {
      log('Erreur dans updateRole : $e');
      throw Exception('Échec de la mise à jour du rôle');
    }
  }

  @override
  Future<void> deleteRole(String roleId) async {
    try {
      final url = Uri.parse('$baseUrl/roles/$roleId');
      final token = await _getToken();
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      log('Requête DELETE /roles/$roleId : ${response.statusCode} - ${response.body}');
      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la suppression : ${response.body}');
      }
    } catch (e) {
      log('Erreur dans deleteRole : $e');
      throw Exception('Échec de la suppression du rôle');
    }
  }

  @override
  Future<void> assignPermissions(String roleId, List<String> permissions) async {
    try {
      await _postRequest('/roles/$roleId/permissions', {'permissions': permissions});
    } catch (e) {
      log('Erreur dans assignPermissions : $e');
      throw Exception('Échec de l’attribution des permissions');
    }
  }

  @override
  Future<void> assignRoleToUser(String userId, String roleId) async {
    try {
      await _postRequest('/user/$userId/role', {'roleId': roleId});
    } catch (e) {
      log('Erreur dans assignRoleToUser : $e');
      throw Exception('Échec de l’assignation du rôle à l’utilisateur');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllRoles() async {
    try {
      final response = await _getRequest('/roles');
      return List<Map<String, dynamic>>.from(response['roles'] ?? []);
    } catch (e) {
      log('Erreur dans getAllRoles : $e');
      throw Exception('Échec du chargement des rôles');
    }
  }

  @override
  Future<List<String>> getAllPermissions() async {
    try {
      final response = await _getRequest('/permissions');
      return List<String>.from(response['permissions'] ?? []);
    } catch (e) {
      log('Erreur dans getAllPermissions : $e');
      throw Exception('Échec du chargement des permissions');
    }
  }
}