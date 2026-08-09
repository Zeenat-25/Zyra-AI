import 'package:permission_handler/permission_handler.dart' as ph;
import '../errors/failures.dart';

class PermissionService {
  static Future<bool> requestLocationPermission() async {
    final status = await ph.Permission.location.request();
    return status.isGranted;
  }

  static Future<bool> requestMicrophonePermission() async {
    final status = await ph.Permission.microphone.request();
    return status.isGranted;
  }

  static Future<bool> requestStoragePermission() async {
    final status = await ph.Permission.storage.request();
    return status.isGranted;
  }

  static Future<bool> requestPhonePermission() async {
    final status = await ph.Permission.phone.request();
    return status.isGranted;
  }

  static Future<bool> requestContactsPermission() async {
    final status = await ph.Permission.contacts.request();
    return status.isGranted;
  }

  static Future<bool> requestNotificationPermission() async {
    final status = await ph.Permission.notification.request();
    return status.isGranted;
  }

  static Future<bool> requestAllCriticalPermissions() async {
    final location = await requestLocationPermission();
    final microphone = await requestMicrophonePermission();
    final storage = await requestStoragePermission();
    final notification = await requestNotificationPermission();
    return location && microphone && storage && notification;
  }

  static Future<bool> checkLocationPermission() async {
    return await ph.Permission.location.isGranted;
  }

  static Future<bool> checkMicrophonePermission() async {
    return await ph.Permission.microphone.isGranted;
  }

  static Future<bool> isPermissionPermanentlyDenied(ph.Permission permission) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }

  static Future<void> openAppSettingsPage() async {
    await ph.openAppSettings();
  }
}
