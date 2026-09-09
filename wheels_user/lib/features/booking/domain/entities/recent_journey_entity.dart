class RecentJourneyEntity {
  final String id;
  final String title;
  final String origin;
  final String timestamp;
  final String iconType; // 'history', 'favorite'

  const RecentJourneyEntity({
    required this.id,
    required this.title,
    required this.origin,
    required this.timestamp,
    required this.iconType,
  });
}
