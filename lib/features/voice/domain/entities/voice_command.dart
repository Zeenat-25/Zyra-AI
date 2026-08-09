class VoiceCommand {
  final int? id;
  final String keyword;
  final String action;
  final bool isActive;
  final String createdAt;

  const VoiceCommand({
    this.id,
    required this.keyword,
    required this.action,
    this.isActive = true,
    required this.createdAt,
  });
}
