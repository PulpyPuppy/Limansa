class Story {
  final int id;
  final String by;
  final DateTime time;
  final int score;
  final int descendants;
  final String title;
  final String? url;
  final List<int> kids;

  const Story({
    required this.id,
    required this.by,
    required this.time,
    required this.score,
    required this.descendants,
    required this.title,
    required this.kids,
    this.url,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] as int,
      by: json['by'] as String? ?? 'unknown',
      time: DateTime.fromMillisecondsSinceEpoch((json['time'] as int) * 1000),
      score: json['score'] as int? ?? 0,
      descendants: json['descendants'] as int? ?? 0,
      title: json['title'] as String? ?? 'notitle',
      url: json['url'] as String?,
      kids: List<int>.from(json['kids'] ?? []),
    );
  }
}
