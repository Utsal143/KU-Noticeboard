class Notice {
  final String title;
  final String content;
  final String imageUrl;
  final String noticesUrl;
  final DateTime scheduledAt;

  Notice({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.noticesUrl,
    required this.scheduledAt,
  });
}
