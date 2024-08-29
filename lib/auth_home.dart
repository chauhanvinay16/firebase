import 'package:firebase/login_screen.dart';
import 'package:flutter/material.dart';
import 'firebase_service/auth_service.dart';

class HomePage extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    String? displayName = _auth.getcurrentusername();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              AuthService().signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
            },
          )
        ],
      ),
      body: Center(
        child: Text(
          displayName != null
              ? 'Welcome, $displayName!'
              : 'Welcome!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
