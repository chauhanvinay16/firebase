import 'dart:convert';
import 'package:firebase/firebase_service/firebase_analytics.dart';
import 'package:firebase/firebase_service/github_oauth_client.dart';
import 'package:firebase/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'email_link_sign_in.dart';
import 'login_screen.dart';

class GoogleLogin extends StatefulWidget {
  const GoogleLogin({super.key});

  @override
  State<GoogleLogin> createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
  bool loading =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Login'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: double.infinity,
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.indigo,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                // // Trigger the authentication flow
                // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                //
                // // Obtain the auth details from the request
                // final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
                //
                // setState(() {loading=true;});
                //
                // // Create a new credential
                // final credential = GoogleAuthProvider.credential(
                //   accessToken: googleAuth?.accessToken,
                //   idToken: googleAuth?.idToken,
                // );
                //
                // // Once signed in, return the UserCredential
                // UserCredential firebaseAuth= await FirebaseAuth.instance.signInWithCredential(credential);

                signInWithGoogle().then((value) {
                  setState(() {loading=false;});

                  print("User Detail:${jsonEncode(value.toString())}");

                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(username: value.user?.displayName??"",),));

                },).onError((error, stackTrace) {
                  print("Error found:${error.toString()}");
                },);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/gog.png',
                    height: 24,
                    width: 24,
                  ),
                  SizedBox(width: 5),

                   loading? Center(child: CircularProgressIndicator()): Text(
                    'Sign up with Google',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            height: 50,
            width: double.infinity,
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.black26,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                  signInWithGitHub().then((value) {
                    setState(() {loading=false;});

                    print("Git User Detail:${jsonEncode(value.toString())}");

                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(username: value.user?.displayName??"",),));

                  },).onError((error, stackTrace) {
                    print('Git Error===>${error.toString()}');
                  },);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://cdn-icons-png.flaticon.com/512/25/25231.png',
                    height: 24,
                    width: 24,
                  ),
                  SizedBox(width: 5),

                  loading? Center(child: CircularProgressIndicator()): Text(
                    'Sign up with Github',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneAuthScreen(),));
                  },
                  child: Text('Phone Authentication',textScaleFactor: 1,))
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FirebaseAnalyticsScreen(),));
                  },
                  child: Text('Firebase Analytics',textScaleFactor: 1,))
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EmailLinkSignIn(),));
                  },
                  child: Text('Firebase wmail link sign in',textScaleFactor: 1,))
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                  },
                  child: Text('Login with email pass',textScaleFactor: 1,))
            ],
          )
        ],
      )
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithGitHub() async {
    // Create a GitHubSignIn instance
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: 'Ov23lihLhszQ0RtVZDAO',
        clientSecret: '544e92e3e3e87dcff737c51deec3a4e945e28ee1',
        redirectUrl: 'https://fir-project-b677f.firebaseapp.com/__/auth/handler');

    // Trigger the sign-in flow
    final result = await gitHubSignIn.signIn(context);

    // Create a credential from the access token
    final githubAuthCredential = GithubAuthProvider.credential(result.token.toString());

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);
  }
}
