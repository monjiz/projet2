class Annonce {
  final String id;
  final String title;
  final String content;
  final String type;
  final String publishedAt;

  Annonce({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.publishedAt,
  });

  factory Annonce.fromJson(Map<String, dynamic> json) {
    return Annonce(
      id: json['id'] ?? '',
      title: json['title'],
      content: json['content'],
      type: json['type'],
      publishedAt: json['publishedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'type': type,
      'publishedAt': publishedAt,
    };
  }

  Annonce copyWith({
    String? id,
    String? title,
    String? content,
    String? type,
    String? publishedAt,
  }) {
    return Annonce(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}
