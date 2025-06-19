import 'dart:convert';
import 'package:auth_firebase/data/models/projet_models.dart';
import 'package:http/http.dart' as http;


class ProjectRepository {
  final String baseUrl = 'https://api.platform.dat.tn/api/v1';

  // 🔹 Ajouter un projet
  Future<void> addProject(ProjectModel project, String token) async {
    final url = Uri.parse('$baseUrl/projects');
    final body = jsonEncode(project.toJson());

    print("DEBUG: POST vers $url");
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
    print("DEBUG: Réponse = ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      String errorMessage = "Erreur lors de l’ajout du projet";
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

  // 🔹 Récupérer tous les projets
  Future<List<ProjectModel>> fetchProjects(String token) async {
    final url = Uri.parse('$baseUrl/projects');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    print("DEBUG: GET $url");
    print("DEBUG: Status = ${response.statusCode}");
    print("DEBUG: Body = ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['data'] == null) {
        throw Exception('La clé \"data\" est absente dans la réponse');
      }

      final List<dynamic> list = jsonData['data'];
      return list.map((e) => ProjectModel.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des projets');
    }
  }

  // 🔹 Supprimer un projet
  Future<void> deleteProject(String id, String token) async {
    final url = Uri.parse('$baseUrl/projects/$id');

    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
    });

    print("DEBUG: DELETE $url");
    print("DEBUG: Status = ${response.statusCode}");

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression du projet');
    }
  }

  // 🔹 Mettre à jour un projet
  Future<void> updateProject(ProjectModel project, String token) async {
    final url = Uri.parse('$baseUrl/projects/${project.id}');
    final body = jsonEncode(project.toJson());

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    print("DEBUG: PUT vers $url");
    print("DEBUG: Status = ${response.statusCode}");
    print("DEBUG: Body = ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la mise à jour du projet');
    }
  }
}
