import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodieapp/data/ingredient/ingredient_repository.dart';
import 'package:foodieapp/data/recipe/recipe_repository.dart';
import 'package:foodieapp/data/user/user_respository.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:foodieapp/data/user/user.dart';
import 'package:foodieapp/models/app_state.dart';
import 'package:foodieapp/screens/home/home_screen.dart';
import 'package:foodieapp/screens/home/home_header.dart';
import 'package:foodieapp/screens/home/search_bar.dart';
import 'package:provider/provider.dart';

import '../mocked_network_image_provider.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockIngredientRepository extends Mock implements IngredientRepository {}

class MockRecipeRepository extends Mock implements RecipeRepository {}

void main() {
  testWidgets('HomeScreen implementation matches its design', (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      await tester.pumpWidget(wrappedHomeScreen());

      expect(find.byType(HomeHeader), findsOneWidget);
      expect(find.byType(SearchBar), findsOneWidget);
    });
  });
}

Widget wrappedHomeScreen() {
  var appState = AppState();
  appState.setCurrentUser(User());
  return MultiProvider(
    child: MaterialApp(home: HomeScreen()),
    providers: [
      ChangeNotifierProvider(
        create: (context) => appState,
      ),
      Provider<UserRepository>(
        create: (context) => MockUserRepository(),
      ),
      Provider<IngredientRepository>(
        create: (context) => MockIngredientRepository(),
      ),
      Provider<RecipeRepository>(
        create: (context) => MockRecipeRepository(),
      ),
    ],
  );
}
