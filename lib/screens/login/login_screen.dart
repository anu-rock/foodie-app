import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/screens/login/email_password_form.dart';
import 'package:foodieapp/screens/signup/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  static const id = 'login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: kPaddingHorizontal,
        decoration: BoxDecoration(
          color: kColorBluegrey,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            EmailPasswordForm(),
            SizedBox(height: 40.0),
            FlatButton(
              color: kColorYellow,
              child: Text('Sign up with Email & Password'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignupScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
