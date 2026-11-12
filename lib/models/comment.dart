class Comment {
  final int id;
  final int parent;
  final String by;
  final DateTime time;
  final String text;
  final List<int> kids;

  const Comment({
    required this.id,
    required this.parent,
    required this.by,
    required this.time,
    required this.text,
    required this.kids,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      parent: json['parent'] as int,
      by: json['by'] as String? ?? 'unknown',
      time: DateTime.fromMillisecondsSinceEpoch((json['time'] as int) * 1000),
      text: json['text'] as String? ?? '',
      kids: List<int>.from(json['kids'] ?? []),
    );
  }
}

