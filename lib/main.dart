import 'dart:io';

import 'package:firebase/google_login.dart';
import 'package:firebase/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if(Platform.isAndroid){
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyBlHYDSCUiFM5LOK555AAajOiL7dFQ3KWQ',
        appId: '1:1061082177940:android:5184456f20c765e23d6f81',
        messagingSenderId: '1061082177940',
        projectId: 'fir-project-b677f',
      ),
    );
  }else{
    await Firebase.initializeApp();

  }
  print('Handling a background message ${message.messageId}');
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isAndroid){
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyBlHYDSCUiFM5LOK555AAajOiL7dFQ3KWQ',
        appId: '1:1061082177940:android:5184456f20c765e23d6f81',
        messagingSenderId: '1061082177940',
        projectId: 'fir-project-b677f',
      ),
    );
  }else{
    await Firebase.initializeApp();
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Firebase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: GoogleLogin(),
    );
  }
}


