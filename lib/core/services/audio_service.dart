import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import '../errors/failures.dart';

class AudioService {
  static FlutterSoundRecorder? _recorder;
  static FlutterSoundPlayer? _player;
  static bool _isInitialized = false;

  static FlutterSoundRecorder get recorder {
    _recorder ??= FlutterSoundRecorder();
    return _recorder!;
  }

  static FlutterSoundPlayer get player {
    _player ??= FlutterSoundPlayer();
    return _player!;
  }

  static Future<void> initialize() async {
    if (_isInitialized) return;
    await recorder.openRecorder();
    await player.openPlayer();
    _isInitialized = true;
  }

  static Future<void> startRecording(String path) async {
    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) {
      throw const AudioFailure('Microphone permission not granted');
    }

    await recorder.startRecorder(
      toFile: path,
      codec: Codec.aacMP4,
    );
  }

  static Future<String?> stopRecording() async {
    return recorder.stopRecorder();
  }

  static Future<void> startPlayback(String path) async {
    await player.startPlayer(
      fromURI: path,
      codec: Codec.aacMP4,
    );
  }

  static Future<void> stopPlayback() async {
    await player.stopPlayer();
  }

  static Future<void> dispose() async {
    if (_isInitialized) {
      await recorder.closeRecorder();
      await player.closePlayer();
      _recorder = null;
      _player = null;
      _isInitialized = false;
    }
  }
}
