import 'package:firebase/main.dart';
import 'package:firebase/screen_two.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

Future<void>featchAndActive()async{
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(seconds: 30),
  ));

  await remoteConfig.setDefaults(const {
    "under_maintenance": false,
    "app_version": '1.0.0',
  });

  await remoteConfig.fetchAndActivate();

  print("under_maintenance${remoteConfig.getBool('under_maintenance')}");
  print("app_version${remoteConfig.getString('app_version')}");

  if(remoteConfig.getBool('under_maintenance')){
      // navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const ScreenTwo(data: {'under_maintenance':'Try After Some Time app is under maintenance.'},),), (route) => false,);
  }

}