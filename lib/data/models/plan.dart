// lib/data/models/plan.dart

import 'package:auth_firebase/data/models/features.dart';

class Plan {
  final String id;
  final String planName;
  final double price;
  final Features features;
  final String userType;
  final String clientId;
  final String workerId;

  Plan({
    required this.id,
    required this.planName,
    required this.price,
    required this.features,
    required this.userType,
    required this.clientId,
    required this.workerId,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    // 1️⃣ Parsing du price (num ou String, fallback à 0)
    final rawPrice = json['price'];
    final double price = rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice?.toString() ?? '') ?? 0.0;

    // 2️⃣ Parsing défensif des Strings (fallback à chaîne vide)
    final String id       = json['id']?.toString()       ?? '';
    final String name     = json['planName']?.toString() ?? '';
    final String userType = json['userType']?.toString() ?? '';
    final String clientId = json['clientId']?.toString() ?? '';
    final String workerId = json['workerId']?.toString() ?? '';

    // 3️⃣ Parsing des features (si null → map vide)
    final featuresJson = json['features'] as Map<String, dynamic>? ?? {};
    final Features features = Features.fromJson(featuresJson);

    return Plan(
      id: id,
      planName: name,
      price: price,
      features: features,
      userType: userType,
      clientId: clientId,
      workerId: workerId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planName': planName,
      'price': price,
      'features': features.toJson(),
      'userType': userType,
      'clientId': clientId,
      'workerId': workerId,
    };
  }
}
