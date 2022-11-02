class Note {
  final int id;
  final String title;
  final String content;
  final String createdAt;
  final String modifiedAt;
  final String token;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.modifiedAt,
    required this.token,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json["ID"],
      title: json["title"],
      content: json["content"],
      createdAt: json['CreatedAt'],
      modifiedAt: json['UpdatedAt'],
      token: json['token']
    );
  }
}