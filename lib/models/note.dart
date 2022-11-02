class Note {
  int? id;
  String title;
  String content;
  final String createdAt;
  final String modifiedAt;
  String token;

  Note({
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
        createdAt: json["CreatedAt"],
        modifiedAt: json["UpdatedAt"],
        token: json["token"]);
  }

  Map<String, dynamic> toJson() =>
      {"ID": id, "title": title, "content": content};
}
