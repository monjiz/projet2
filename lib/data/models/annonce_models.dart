import 'package:equatable/equatable.dart';

class Annonce extends Equatable {
  final String id;
  final String titre;
  final String contenu;
  final String datePublication;
  final String type;

  Annonce({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.datePublication,
    required this.type,
  });

  // Conversion JSON vers un objet Annonce
  factory Annonce.fromJson(Map<String, dynamic> json) {
    return Annonce(
      id: json['id'] as String,
      titre: json['titre'] as String,
      contenu: json['contenu'] as String,
      datePublication: json['datePublication'] as String,
      type: json['type'] as String,
    );
  }

  // Conversion objet Annonce vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'contenu': contenu,
      'datePublication': datePublication,
      'type': type,
    };
  }

  @override
  List<Object?> get props => [id, titre, contenu, datePublication, type];
}