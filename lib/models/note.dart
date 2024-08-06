import 'package:hive/hive.dart';

//part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  String timestamp;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  factory Note.fromMap(Map<String, dynamic> json) => Note(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "content": content,
        "timestamp": timestamp,
      };
}
