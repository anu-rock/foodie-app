import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/screens/app_root/app_root_screen.dart';
import 'package:foodieapp/screens/login/login_screen.dart';
import 'package:foodieapp/models/app_state.dart';
import 'package:foodieapp/data/user/user_respository.dart';
import 'package:foodieapp/data/user/firebase_user_repository.dart';
import 'package:foodieapp/data/ingredient/firebase_ingredient_repository.dart';
import 'package:foodieapp/data/ingredient/ingredient_repository.dart';

void main() => runApp(FoodieApp());

class FoodieApp extends StatelessWidget {
  final _appState = AppState();

  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    UserRepository user = FirebaseUserRepository();

    return MultiProvider(
      providers: [
        // State
        ChangeNotifierProvider<AppState>(
          create: (context) => this._appState,
        ),
        // Dependency injection
        Provider<UserRepository>(
          create: (context) => FirebaseUserRepository(),
        ),
        Provider<IngredientRepository>(
          create: (context) => FirebaseIngredientRepository(),
        ),
      ],
      child: MaterialApp(
        title: 'Foodie App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder(
          stream: user.onAuthChanged(),
          builder: (context, snapshot) {
            final user = snapshot.data;
            if (user == null) {
              return LoginScreen();
            }
            this._appState.setCurrentUser(user);
            return AppRootScreen();
          },
        ),
      ),
    );
  }
}
