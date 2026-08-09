class AppConstants {
  AppConstants._();

  static const String appName = 'Zyra';
  static const String tagline = 'Your Voice. Your Safety.';
  static const String appVersion = '1.0.0';

  static const String defaultCountryCode = '+1';
  static const int splashDurationSeconds = 3;
  static const int sosCooldownSeconds = 10;
  static const int locationUpdateIntervalMs = 30000;
  static const int voiceListeningTimeoutSeconds = 60;

  static const List<String> defaultSosKeywords = [
    'help',
    'help me',
    'emergency',
    'sos',
    'save me',
    'i need help',
    'danger',
  ];

  static const String databaseName = 'zyra.db';
  static const int databaseVersion = 1;

  static const String prefKeyUser = 'pref_key_user';
  static const String prefKeyTheme = 'pref_key_theme';
  static const String prefKeySosKeywords = 'pref_key_sos_keywords';
  static const String prefKeyAutoLocation = 'pref_key_auto_location';
  static const String prefKeyVoiceDetection = 'pref_key_voice_detection';
  static const String prefKeyOnboardingDone = 'pref_key_onboarding_done';
}
