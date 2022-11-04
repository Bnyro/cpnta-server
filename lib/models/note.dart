import 'package:floor/floor.dart';

@entity
class Note {
  @PrimaryKey(autoGenerate: false)
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

  factory Note.empty() {
    return Note(
        id: null,
        content: "",
        title: "",
        createdAt: "",
        modifiedAt: "",
        token: "");
  }

  Map<String, dynamic> toJson() =>
      {"ID": id, "title": title, "content": content};
}
