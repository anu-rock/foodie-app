import 'package:flutter/material.dart';
import 'package:foodieapp/widgets/tabs_bar.dart';

class ProfileScreen extends StatelessWidget {
  static const id = 'profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TabsBar(),
      body: Center(
        child: Text('Profile'),
      ),
    );
  }
}
