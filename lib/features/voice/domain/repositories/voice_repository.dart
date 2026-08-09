import '../entities/voice_command.dart';

abstract class VoiceRepository {
  Future<List<VoiceCommand>> getActiveCommands();
  Future<void> addCommand(VoiceCommand command);
  Future<void> removeCommand(int id);
  Future<void> toggleCommand(int id, bool isActive);
}
