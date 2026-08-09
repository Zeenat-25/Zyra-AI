import 'package:speech_to_text/speech_to_text.dart';
import '../errors/failures.dart';
import '../constants/app_constants.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    _isInitialized = await _speech.initialize(
      onError: (error) {
        throw VoiceDetectionFailure(error.errorMsg);
      },
      onStatus: (status) {},
    );
    return _isInitialized;
  }

  Future<void> startListening({
    required Function(String text) onResult,
    Function(String keyword)? onKeywordDetected,
    List<String>? keywords,
    int? timeoutSeconds,
  }) async {
    if (_isListening) return;

    final available = await initialize();
    if (!available) {
      throw const VoiceDetectionFailure('Speech recognition not available');
    }

    _isListening = true;
    final watchKeywords = keywords ?? AppConstants.defaultSosKeywords;

    await _speech.listen(
      onResult: (result) {
        if (!result.finalResult) return;
        final text = result.recognizedWords.toLowerCase();
        onResult(text);

        for (final keyword in watchKeywords) {
          if (text.contains(keyword.toLowerCase())) {
            onKeywordDetected?.call(keyword);
            break;
          }
        }
      },
      listenFor: Duration(seconds: timeoutSeconds ?? 60),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      localeId: 'en_US',
      listenMode: ListenMode.confirmation,
    );
  }

  Future<void> stopListening() async {
    if (!_isListening) return;
    await _speech.stop();
    _isListening = false;
  }

  bool get isListening => _isListening;
  bool get isAvailable => _speech.isAvailable;

  Future<List<String>> getAvailableLocales() async {
    final locales = await _speech.locales();
    return locales.map((l) => l.localeId).toList();
  }
}
