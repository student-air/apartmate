import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

/// Wraps flutter_local_notifications behind a simple init/permission/show
/// API. Call AppNotificationService.init() once in main() before runApp().
class AppNotificationService {
  AppNotificationService._();
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);
    _initialized = true;
  }

  /// Requests the OS-level notification permission (Android 13+ requires
  /// this explicitly; on older Android it's a no-op that returns granted).
  /// Returns true if permission is granted.
  static Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  static Future<bool> hasPermission() async {
    return await Permission.notification.isGranted;
  }

  static Future<void> show({
    required int id,
    required String title,
    required String body,
    String channelId = 'apartmate_general',
    String channelName = 'General',
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.high,
      priority: Priority.high,
    );
    final details = NotificationDetails(android: androidDetails);
    await _plugin.show(id, title, body, details);
  }
}