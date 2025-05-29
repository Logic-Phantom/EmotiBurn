import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // 타임존 초기화
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // 알림 탭했을 때의 동작
        debugPrint('알림이 탭되었습니다: ${response.payload}');
      },
    );
  }

  static Future<void> showPeriodicNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'emotiburn_channel',
      'EmotiBurn 알림',
      channelDescription: '정기적으로 마음 상태를 체크하는 알림',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    try {
      // 기존 알림 취소
      await _notificationsPlugin.cancelAll();
      
      // 새로운 주기적 알림 설정
      await _notificationsPlugin.periodicallyShow(
        0,
        'EmotiBurn',
        '지금 마음은 괜찮나요?',
        RepeatInterval.hourly,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
      );
      debugPrint('주기적 알림이 성공적으로 설정되었습니다.');
    } catch (e) {
      debugPrint('알림 설정 실패: $e');
    }
  }

  static Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
} 