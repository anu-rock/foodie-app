import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const id = 'profile';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlatButton(
        child: Text('Logout'),
        onPressed: () => FirebaseAuth.instance.signOut(),
      ),
    );
  }
}
