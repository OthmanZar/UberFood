import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:projetc2/screens/city_selection_screen.dart';

import 'dart:convert';
import '../models/UserData.dart';
import '../screens/auth_screen.dart';

import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? accessToken;
  String? userId;

  Future<void> signOut(BuildContext context) async {
    Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
  }

  Future<void> addUser(UserData userData) async {
    final url =
        'http://192.168.0.165:8800/add/user'; // Replace with your API endpoint
    final body = jsonEncode(userData.toJson());
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // Data added successfully
    } else {
      // Handle error response
      print('Failed to add user. Error: ${response.statusCode}');
    }
  }

  Future<void> forgot(String email, BuildContext context) async {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    Navigator.of(context)
        .pushReplacementNamed(AuthScreen.routeName, arguments: 0);
  }

  Future<void> signUp(
      String email, String password, String name, BuildContext context) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    if (userCredential != null) {
      final newUser = UserData(email: email, name: name, role: 'Client');
      addUser(newUser);

      Navigator.of(context)
          .pushReplacementNamed(AuthScreen.routeName, arguments: 0);
    }
    //  }
    // }).catchError((e) {
    // debugPrint(e);
    // });
  }

  Future signIn(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Sign-in successful
      if (userCredential != null) {
        print('Sign-in successful');

        Navigator.of(context)
            .pushReplacementNamed(CitySelectionScreen.routeName, arguments: 0);

        // You can access the signed-in user with userCredential.user
        // For example: User user = userCredential.user;
      }
    } catch (e) {
      // Sign-in unsuccessful
      print('Sign-in failed. Error: $e');
    }
  }
}
