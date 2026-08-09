sealed class Failure {
  final String message;
  const Failure(this.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class LocationFailure extends Failure {
  const LocationFailure(super.message);
}

class AudioFailure extends Failure {
  const AudioFailure(super.message);
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

class VoiceDetectionFailure extends Failure {
  const VoiceDetectionFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
