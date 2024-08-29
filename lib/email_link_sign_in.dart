import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailLinkSignIn extends StatefulWidget {
  @override
  _EmailLinkSignInState createState() => _EmailLinkSignInState();
}

class _EmailLinkSignInState extends State<EmailLinkSignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkForSignInLink();
  }

  // Check if the app was opened with a sign-in link
  void _checkForSignInLink() async {
    final Uri? link = await _retrieveDeepLink();

    if (link != null && _auth.isSignInWithEmailLink(link.toString())) {
      String? email = await _retrieveEmail();

      if (email != null) {
        try {
          final UserCredential userCredential = await _auth.signInWithEmailLink(
            email: email,
            emailLink: link.toString(),
          );

          if (userCredential.user != null) {
            print('Successfully signed in with email link!');
            // Navigate to the home screen or update UI
          }
        } catch (e) {
          print('Error signing in with email link: $e');
        }
      } else {
        print('No email found for sign-in.');
        // Prompt user to enter their email again
      }
    }
  }

  // Send the sign-in link to the entered email
  Future<void> _sendLink() async {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      await sendSignInLink(email);
    } else {
      print('Please enter a valid email.');
      // Optionally, show a message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in with Email Link'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            ElevatedButton(
              onPressed: _sendLink,
              child: Text('Send Sign-in Link'),
            ),
          ],
        ),
      ),
    );
  }
}

// Send the sign-in link via email and save the email locally
Future<void> sendSignInLink(String email) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ActionCodeSettings actionCodeSettings = ActionCodeSettings(
    url: 'https://fir-project-b677f.firebaseapp.com',
    handleCodeInApp: true,
    androidPackageName: 'com.example.firebase',
    androidInstallApp: true,
    iOSBundleId: 'com.example.firebase',
  );

  try {
    await _auth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: actionCodeSettings,
    );

    // Save the email locally for use when verifying the link
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);

    print('Email sent to $email');
  } catch (error) {
    print('Problem Found: ${
        error.toString()}');
  }
}

// Retrieve the deep link used to open the app
Future<Uri?> _retrieveDeepLink() async {
  final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
  return data?.link;
}

// Retrieve the saved email from local storage
Future<String?> _retrieveEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}
