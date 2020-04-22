import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodieapp/data/user/user_respository.dart';

class ProfileScreen extends StatelessWidget {
  static const id = 'profile';

  @override
  Widget build(BuildContext context) {
    var userRepo = Provider.of<UserRepository>(context);

    return Center(
      child: FlatButton(
        child: Text('Logout'),
        onPressed: () => userRepo.logout(),
      ),
    );
  }
}
