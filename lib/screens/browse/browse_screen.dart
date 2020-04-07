import 'package:flutter/material.dart';
import 'package:foodieapp/widgets/tabs_bar.dart';

class BrowseScreen extends StatelessWidget {
  static const id = 'browse';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TabsBar(),
      body: Center(
        child: Text('Browse'),
      ),
    );
  }
}
