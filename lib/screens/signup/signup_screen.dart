import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/screens/signup/email_password_form.dart';

class SignupScreen extends StatelessWidget {
  static const id = 'signup';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: kPaddingAll,
        decoration: BoxDecoration(
          color: kColorBluegrey,
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              EmailPasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}
