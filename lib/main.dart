import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/data/user/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/screens/app_root/app_root_screen.dart';
import 'package:foodieapp/screens/login/login_screen.dart';
import 'package:foodieapp/models/app_state.dart';
import 'package:foodieapp/data/user/user_respository.dart';
import 'package:foodieapp/data/user/firebase_user_repository.dart';
import 'package:foodieapp/data/ingredient/firebase_ingredient_repository.dart';
import 'package:foodieapp/data/ingredient/ingredient_repository.dart';
import 'package:foodieapp/data/recipe/recipe_repository.dart';
import 'package:foodieapp/data/recipe/hybrid_recipe_repository.dart';
import 'package:foodieapp/data/status/firebase_status_repository.dart';
import 'package:foodieapp/data/status/status_repository.dart';
import 'package:foodieapp/data/network/firebase_network_repository.dart';
import 'package:foodieapp/data/network/network_repository.dart';

void main() => runApp(FoodieApp());

class FoodieApp extends StatefulWidget {
  @override
  _FoodieAppState createState() => _FoodieAppState();
}

class _FoodieAppState extends State<FoodieApp> {
  User currentUser;
  bool isAppStateInitialized = false;

  void _initializeAppState(BuildContext context) async {
    if (this.isAppStateInitialized == false) {
      print('initializing global app state');
      final appState = Provider.of<AppState>(context, listen: false);
      final networkRepo = Provider.of<NetworkRepository>(context, listen: false);
      appState.setCurrentUser(this.currentUser);
      final currentUserFollowees = networkRepo.getFollowees(this.currentUser.id);
      appState.setFollowees(await currentUserFollowees.first);
      this.isAppStateInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    UserRepository user = FirebaseUserRepository();

    return MultiProvider(
      providers: [
        // State
        ChangeNotifierProvider<AppState>(
          create: (context) => AppState(),
        ),
        // Dependency injection
        Provider<UserRepository>(
          create: (context) => FirebaseUserRepository(),
        ),
        Provider<IngredientRepository>(
          create: (context) => FirebaseIngredientRepository(),
        ),
        Provider<RecipeRepository>(
          create: (context) => HybridRecipeRepository(),
        ),
        Provider<StatusRepository>(
          create: (context) => FirebaseStatusRepository(),
        ),
        Provider<NetworkRepository>(
          create: (context) => FirebaseNetworkRepository(),
        ),
      ],
      child: MaterialApp(
        title: 'Foodie App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.notoSansTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: StreamBuilder<User>(
          stream: user.onAuthChanged(),
          builder: (context, snapshot) {
            final user = snapshot.data;

            if (user == null) {
              return LoginScreen();
            }

            this.currentUser = user;

            _initializeAppState(context);

            return AppRootScreen();
          },
        ),
      ),
    );
  }
}
