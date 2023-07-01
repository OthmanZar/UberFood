import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../provider/auth_provider.dart';

import '../widgets/action_button.dart';

class OnBoarding2 extends StatefulWidget {
  static const routeName = "/onboarding2";
  const OnBoarding2({Key? key}) : super(key: key);
  @override
  _OnBoarding2State createState() => _OnBoarding2State();
}

class _OnBoarding2State extends State<OnBoarding2> {
  String email = '';
  Auth auth = Auth();
  final TextEditingController emailController = TextEditingController();

  void storeEmail() {
    final String email = emailController.text.trim();

    if (email.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Veuillez entrer une adresse e-mail.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    final bool isValidEmail =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(email);

    if (!isValidEmail) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Veuillez entrer une adresse e-mail valide.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // The email is valid, perform further processing
    print(email);
    auth.forgot(email, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mot De Pass Oublié'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 60.h,
              child: ClipRRect(
                child: Image.asset("assets/images/food_illistration.jpg"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un mot de passe";
                  }
                  return null;
                },
              ),
            ),
            ActionButton(
              onTap: storeEmail,
              text: ('Envoyer Email'),
              height: 40,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
