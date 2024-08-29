import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotification{

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void requestPermition()async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<String>getDeviceToken()async{
    String? getDeviceToken=await messaging.getToken();
    print("Device Token==>${getDeviceToken}");
    return getDeviceToken??"";
  }

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'VinayFirebase', // id
    'High Importance Notifications', // title
    importance: Importance.max,
    showBadge: true,
    playSound: true,
    enableLights: true,
    enableVibration: true,
  );

  initLocalNotification()async{
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    AndroidInitializationSettings initializationSettingsAndroid= const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsios= const DarwinInitializationSettings();

    var initializationSettings= InitializationSettings(android: initializationSettingsAndroid,iOS: initializationSettingsios);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response){

      }
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (Platform.isAndroid) {
        flutterLocalNotificationsPlugin.show(
            1,
            message.notification?.title,
            message.notification?.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'VinayFirebase',
                'VinayFirebase',
                channelDescription: 'chenal_description',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker',
                // icon: 'ic_launcher'
              ),
            ),
          payload: jsonEncode(message.data),
        );
      }if(Platform.isIOS){
        await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true, // Required to display a heads up notification
          badge: true,
          sound: true,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){

    });
  }
  void openFromterminateState()async{
    RemoteMessage? message=await FirebaseMessaging.instance.getInitialMessage();
    if(message!=null){

    }
  }

  static void _handelNotificationResponse(Map<String,dynamic>data){
    if(data['type']=='1'){

    }
  }
}