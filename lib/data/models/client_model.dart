class ClientModel {
  final String id;
  final String name;
  final double? rating; // Typé correctement

  ClientModel({
    required this.id,
    required this.name,
    this.rating,
  });

  // Getter pour specialty, avec une implémentation par défaut ou supprimable si non utilisé
  String? get specialty => null;
}