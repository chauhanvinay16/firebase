import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  String _verificationId = '';

  Future<void> _requestVerificationCode() async {
    int retryCount = 0;
    const int maxRetries = 5;
    const int retryDelay = 2000; // 2 seconds

    while (retryCount < maxRetries) {
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
            final User? user = (await _auth.signInWithCredential(credential)).user;
            print('Signed in: ${user?.uid}');
          },
          verificationFailed: (FirebaseAuthException e) async {
            print('Phone Auth Error: $e');
            if (e.code == 'too-many-requests') {
              retryCount++;
              if (retryCount < maxRetries) {
                await Future.delayed(Duration(milliseconds: retryDelay * retryCount));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Too many requests. Please try again later.')),
                );
                return; // Exit the function after max retries
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Phone Auth Error: ${e.message}')),
              );
              return; // Exit the function if a different error occurs
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              _verificationId = verificationId;
            });
            // Successfully sent the code, so exit the loop
            return;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print('Auto-retrieval timeout reached');
          },
        );
        return; // Exit the loop after successfully sending the code
      } catch (e) {
        print('Phone Auth Error: $e');
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(Duration(milliseconds: retryDelay * retryCount));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error occurred. Please try again later.')),
          );
          return; // Exit the function after max retries
        }
      }
    }
  }


  Future<void> _handleVerificationCode() async {
    try {
      final smsCode = _smsCodeController.text;
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );

      // Sign in with the credential
      final User? user = (await _auth.signInWithCredential(credential)).user;
      print('Signed in: ${user?.uid}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Verified')));

    } catch (e) {
      print('Phone Auth Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Auth Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _requestVerificationCode,
              child: Text('Request Verification Code'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _smsCodeController,
              decoration: InputDecoration(
                labelText: 'Verification Code',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleVerificationCode,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

