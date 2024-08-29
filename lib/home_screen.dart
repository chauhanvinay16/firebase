import 'package:firebase/firebase_service/push_notification.dart';
import 'package:firebase/firebase_service/remote_config.dart';
import 'package:firebase/google_login.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    PushNotification().requestPermition();
    PushNotification().getDeviceToken();
    PushNotification().initLocalNotification();
    PushNotification().openFromterminateState();
    featchAndActive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white,),
        title: Text('Home',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text('Welcome${widget.username}',textScaleFactor: 2,),
            ),
            SizedBox(height: 20,),

            Row(
              children: [
                ElevatedButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleLogin(),));
                }, child: Text('Google_Login')),

                SizedBox(width: 8,),

                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(onPressed: () async{
                    await GoogleSignIn().signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const GoogleLogin(),));
                  }, icon: Icon(Icons.login_outlined,color: Colors.white,)),
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
}
