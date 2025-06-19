import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auth_firebase/data/models/plan.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionRepository {
  static const String _baseUrl = 'https://api.platform.dat.tn/api/v1/subscription-plans';

  /// Récupère le JWT stocké en local
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      throw Exception('Token d’authentification manquant');
    }
    return token;
  }

  /// Construit les headers à chaque appel
  Future<Map<String, String>> _buildHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
Future<List<Plan>> getPlans() async {
  final uri = Uri.parse(_baseUrl);
  final headers = await _buildHeaders();

  final res = await http.get(uri, headers: headers);
  log('GET $uri → ${res.statusCode}\n${res.body}');

  if (res.statusCode == 200) {
    // 1) Décoder en Map
    final Map<String, dynamic> root = jsonDecode(res.body);
    // 2) Extraire la liste qui est sous la clé 'data'
    final List<dynamic> list = root['data'] as List<dynamic>;
    // 3) Mapper vers Plan
    return list.map((e) => Plan.fromJson(e as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Erreur ${res.statusCode} → ${res.body}');
  }
}


  Future<Plan> createPlan(Plan plan) async {
    final uri = Uri.parse(_baseUrl);
    final headers = await _buildHeaders();
    final body = jsonEncode(plan.toJson());

    final res = await http.post(uri, headers: headers, body: body);
    log('POST $uri\n$body → ${res.statusCode}\n${res.body}');
    if (res.statusCode == 201 || res.statusCode == 200) {
      return Plan.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Erreur ${res.statusCode} création : ${res.body}');
    }
  }

Future<Plan> updatePlan(String id, Plan plan) async {
  final uri = Uri.parse('$_baseUrl/$id');
  final headers = await _buildHeaders();

  final planJson = plan.toJson();
  planJson.remove('id'); // ✅ Enlève "id" pour éviter l’erreur 500
  final body = jsonEncode(planJson);

  final res = await http.patch(uri, headers: headers, body: body);
  log('PATCH $uri\n$body → ${res.statusCode}\n${res.body}');

  if (res.statusCode == 200) {
    return Plan.fromJson(jsonDecode(res.body));
  } else {
    throw Exception('Erreur ${res.statusCode} mise à jour : ${res.body}');
  }
}



  Future<void> deletePlan(String id) async {
    final uri = Uri.parse('$_baseUrl/$id');
    final headers = await _buildHeaders();

    final res = await http.delete(uri, headers: headers);
    log('DELETE $uri → ${res.statusCode}\n${res.body}');
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Erreur ${res.statusCode} suppression : ${res.body}');
    }
  }
}
