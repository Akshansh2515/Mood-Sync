class Note {
  int? id;
  String title;
  String content;
  DateTime timestamp;
  Map<String, double> emotions;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.emotions,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      emotions: Map<String, double>.from(json['emotions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'emotions': emotions,
    };
  }
}
