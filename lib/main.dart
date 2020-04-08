import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/screens/app_root/app_root_screen.dart';
import 'package:provider/provider.dart';
import 'package:foodieapp/models/app_state.dart';

void main() => runApp(FoodieApp());

class FoodieApp extends StatelessWidget {
  final appState = AppState();

  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => this.appState,
      child: MaterialApp(
        title: 'Foodie App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AppRootScreen(),
      ),
    );
  }
}
