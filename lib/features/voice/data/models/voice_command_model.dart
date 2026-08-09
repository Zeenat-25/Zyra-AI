import 'package:zyra/features/voice/domain/entities/voice_command.dart';

class VoiceCommandModel extends VoiceCommand {
  const VoiceCommandModel({
    super.id,
    required super.keyword,
    required super.action,
    super.isActive,
    required super.createdAt,
  });

  factory VoiceCommandModel.fromMap(Map<String, dynamic> map) {
    return VoiceCommandModel(
      id: map['id'] as int,
      keyword: map['keyword'] as String,
      action: map['action'] as String,
      isActive: (map['isActive'] as int) == 1,
      createdAt: map['createdAt'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'keyword': keyword,
      'action': action,
      'isActive': isActive ? 1 : 0,
      'createdAt': createdAt,
    };
  }
}
