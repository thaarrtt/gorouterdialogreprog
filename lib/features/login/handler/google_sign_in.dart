import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:loggy/loggy.dart';

class CustomGoogleSignIn {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        "534580921967-e6obtu62jevnikajjp5v95eo0doe6jjr.apps.googleusercontent.com",
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  Future<dynamic> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      // Get authentication credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Send token to your custom backend
      final response = await _sendTokenToBackend(
          idToken: googleAuth.idToken!, accessToken: googleAuth.accessToken!);

      return response;
    } catch (error) {
      logInfo('Google Sign-In Error: $error');
      return null;
    }
  }

  Future<dynamic> _sendTokenToBackend(
      {required String idToken, required String accessToken}) async {
    try {
      final url = Uri.parse('https://your-backend-url.com/callback');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'idToken': idToken,
          'accessToken': accessToken,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        logInfo('Backend error: ${response.body}');
        return null;
      }
    } catch (e) {
      logInfo('Network error: $e');
      return null;
    }
  }
}

class GoogleSignInButton extends StatelessWidget {
  final CustomGoogleSignIn _customGoogleSignIn = CustomGoogleSignIn();

  GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final result = await _customGoogleSignIn.signInWithGoogle();
        if (result != null) {
          // Handle successful sign-in
          logInfo('Signed in successfully: $result');
        } else {
          // Handle sign-in failure
          logInfo('Sign-in failed');
        }
      },
      child: const Text('Sign in with Google'),
    );
  }
}
