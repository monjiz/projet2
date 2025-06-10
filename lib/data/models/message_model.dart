class Message {
  final String id;
  final String titre;
  final String contenu;
  final String destinataire;
  final String date;

  Message({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.destinataire,
    required this.date,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      titre: json['titre'] ?? '',
      contenu: json['contenu'] ?? '',
      destinataire: json['destinataire'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'contenu': contenu,
      'destinataire': destinataire,
      'date': date,
    };
  }
}
