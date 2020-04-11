import 'package:flutter/material.dart';
import 'package:foodieapp/data/user/firebase_user_repository.dart';
import 'package:foodieapp/data/user/user_respository.dart';

final UserRepository user = FirebaseUserRepository();

class ProfileScreen extends StatelessWidget {
  static const id = 'profile';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlatButton(
        child: Text('Logout'),
        onPressed: () => user.logout(),
      ),
    );
  }
}
