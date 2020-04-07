import 'package:flutter/material.dart';
import 'package:foodieapp/widgets/tabs_bar.dart';

class ShopScreen extends StatelessWidget {
  static const id = 'shop';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TabsBar(),
      body: Center(
        child: Text('Shop'),
      ),
    );
  }
}
