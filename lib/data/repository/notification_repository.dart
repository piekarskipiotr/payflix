import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/common/api_keys.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/model/notification.dart' as model;
import 'package:payflix/data/model/notification_content.dart';
import 'package:payflix/data/model/notification_data.dart';
import 'package:payflix/widgets/permission_dialog.dart';

@singleton
class NotificationRepository {
  final _instance = FirebaseMessaging.instance;
  final _messaging = FirebaseMessaging.onMessage;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    enableVibration: true,
  );

  FirebaseMessaging instance() => _instance;

  Stream<RemoteMessage> messageStream() => _messaging;

  Future requestPermission(BuildContext context) async {
    NotificationSettings settings = await instance().requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => const PermissionDialog(
            permission: 'push-notifications',
            asset: explaining,
          ),
        ),
      );
    }
  }

  Future loadFCM() async {
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await instance().setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future listenFCM() async {
    messageStream().listen(
      (message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: 'launch_background',
              ),
            ),
          );
        }
      },
    );
  }

  void sendPushMessage(
    String title,
    String body,
    List<String> tokens,
    String action,
  ) async {
    try {
      final dio = Dio(
        BaseOptions(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'key=${ApiKeys.fcmKey}',
          },
        ),
      );

      for (final token in tokens) {
        final notification = model.Notification(
          content: NotificationContent(
            title: title,
            body: body,
          ),
          data: NotificationData(
            id: '1',
            action: action,
            status: 'done',
          ),
          priority: 'high',
          destinationToken: token,
        );

        final response = await dio.post(
          'https://fcm.googleapis.com/fcm/send',
          data: notification,
        );
        log(response.toString());
      }
    } catch (e) {
      log("error push notification");
    }
  }
}
