class Projet {
  final String id;
  final String titre;
  final String description;
  final String status;

  Projet({
    required this.id,
    required this.titre,
    required this.description,
    required this.status,
  });

  factory Projet.fromJson(Map<String, dynamic> json) {
    return Projet(
      id: json['id'] ?? '',
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'status': status,
    };
  }
}
