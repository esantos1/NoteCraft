import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note {
  Note({
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  @HiveField(0)
  String title;

  @HiveField(1)
  String body;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  DateTime updatedAt;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        title: json['title'],
        body: json['body'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  @override
  String toString() {
    return 'Note(title: $title, body: ${body.length > 10 ? '${body.substring(0, 10)}...' : body}, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
