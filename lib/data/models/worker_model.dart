class Worker {
  final String id;
  final String name;
  final double? rating;
  final String? specialty;

  Worker({
    required this.id,
    required this.name,
    this.rating,
    this.specialty,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : json['rating']?.toDouble(),
      specialty: json['specialty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
      'specialty': specialty,
    };
  }
}
