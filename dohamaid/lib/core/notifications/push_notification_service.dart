import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../data/datasources/storage_local_data_source.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background notification received: ${message.messageId}');
}

class PushNotificationService {
  PushNotificationService({
    FirebaseMessaging? firebaseMessaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  })  : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance,
        _localNotifications =
            localNotifications ?? FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  static const String notificationRouteKey = 'NOTIFICATION_ROUTE';
  static const String notificationPayloadKey = 'NOTIFICATION_PAYLOAD';

  Future<NotificationSettings> requestPermissions() async {
    return _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  Future<void> initialize() async {
    await _initializeLocalNotifications();
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _initializeLocalNotifications() async {
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for important notifications.',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(initializationSettings);
  }

  Future<void> showLocal(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  Stream<RemoteMessage> get foregroundMessages => FirebaseMessaging.onMessage;

  Stream<RemoteMessage> get openedFromBackground =>
      FirebaseMessaging.onMessageOpenedApp;

  Future<RemoteMessage?> getInitialMessage() =>
      _firebaseMessaging.getInitialMessage();

  Future<void> cacheRouteFromMessage(RemoteMessage message) async {
    final page = message.data['page']?.toString();
    if (page == null || page.isEmpty) return;

    await StorageLocalDataSource.prefsSync
        .setString(notificationRouteKey, page.trim());
    await StorageLocalDataSource.prefsSync.setString(
      notificationPayloadKey,
      jsonEncode(message.data),
    );
  }

  String? getSavedRoute() {
    return StorageLocalDataSource.prefsSync.getString(notificationRouteKey);
  }

  Map<String, dynamic> getSavedPayload() {
    final jsonString =
    StorageLocalDataSource.prefsSync.getString(notificationPayloadKey);
    if (jsonString == null || jsonString.isEmpty) {
      return <String, dynamic>{};
    }

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  Future<void> clearCachedRoute() async {
    await StorageLocalDataSource.prefsSync.remove(notificationRouteKey);
    await StorageLocalDataSource.prefsSync.remove(notificationPayloadKey);
  }
}
