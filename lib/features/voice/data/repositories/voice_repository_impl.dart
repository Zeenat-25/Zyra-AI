import 'package:zyra/features/voice/domain/entities/voice_command.dart';
import 'package:zyra/features/voice/domain/repositories/voice_repository.dart';
import '../datasources/voice_datasource.dart';
import '../models/voice_command_model.dart';

class VoiceRepositoryImpl implements VoiceRepository {
  final VoiceDataSource _dataSource;

  VoiceRepositoryImpl(this._dataSource);

  @override
  Future<List<VoiceCommand>> getActiveCommands() async {
    return _dataSource.getActiveCommands();
  }

  @override
  Future<void> addCommand(VoiceCommand command) async {
    final model = VoiceCommandModel(
      keyword: command.keyword,
      action: command.action,
      createdAt: command.createdAt,
    );
    await _dataSource.insertCommand(model);
  }

  @override
  Future<void> removeCommand(int id) async {
    await _dataSource.deleteCommand(id);
  }

  @override
  Future<void> toggleCommand(int id, bool isActive) async {
    await _dataSource.updateCommandStatus(id, isActive);
  }
}
