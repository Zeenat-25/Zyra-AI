import 'package:flutter/material.dart';
import 'package:zyra/core/services/voice_service.dart';
import 'package:zyra/core/constants/app_constants.dart';
import 'package:zyra/features/voice/data/datasources/voice_datasource.dart';
import 'package:zyra/features/voice/data/repositories/voice_repository_impl.dart';
import 'package:zyra/features/voice/domain/entities/voice_command.dart';

class VoiceProvider extends ChangeNotifier {
  final VoiceRepositoryImpl _repository;
  final VoiceService _voiceService;

  List<VoiceCommand> _commands = [];
  bool _isListening = false;
  bool _isInitialized = false;
  String? _lastHeardText;
  String? _detectedKeyword;
  bool _voiceDetectionEnabled = true;

  VoiceProvider()
      : _repository = VoiceRepositoryImpl(VoiceDataSource()),
        _voiceService = VoiceService();

  List<VoiceCommand> get commands => _commands;
  bool get isListening => _isListening;
  bool get isInitialized => _isInitialized;
  String? get lastHeardText => _lastHeardText;
  String? get detectedKeyword => _detectedKeyword;
  bool get voiceDetectionEnabled => _voiceDetectionEnabled;

  Future<void> initialize() async {
    _isInitialized = await _voiceService.initialize();
    if (_isInitialized) {
      await loadCommands();
    }
    notifyListeners();
  }

  Future<void> loadCommands() async {
    _commands = await _repository.getActiveCommands();
    notifyListeners();
  }

  Future<void> startListening({
    required Function(String keyword) onKeywordDetected,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    _isListening = true;
    notifyListeners();

    await _voiceService.startListening(
      onResult: (text) {
        _lastHeardText = text;
        notifyListeners();
      },
      onKeywordDetected: (keyword) {
        _detectedKeyword = keyword;
        notifyListeners();
        onKeywordDetected(keyword);
      },
      keywords: _commands.map((c) => c.keyword).toList(),
    );
  }

  Future<void> stopListening() async {
    await _voiceService.stopListening();
    _isListening = false;
    notifyListeners();
  }

  Future<void> toggleVoiceDetection() async {
    _voiceDetectionEnabled = !_voiceDetectionEnabled;
    await _savePreference();
    notifyListeners();
  }

  Future<void> addCustomKeyword(String keyword, String action) async {
    final command = VoiceCommand(
      keyword: keyword.toLowerCase(),
      action: action,
      createdAt: DateTime.now().toIso8601String(),
    );
    await _repository.addCommand(command);
    await loadCommands();
  }

  Future<void> removeKeyword(int id) async {
    await _repository.removeCommand(id);
    await loadCommands();
  }

  Future<void> _savePreference() async {
    // Save to SharedPreferences
  }
}
