import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodieapp/data/user/user.dart';
import 'package:foodieapp/models/app_state.dart';
import 'package:foodieapp/screens/home/home_screen.dart';
import 'package:foodieapp/screens/home/home_header.dart';
import 'package:foodieapp/screens/home/search_bar.dart';
import 'package:foodieapp/screens/home/home_cta_tile.dart';
import 'package:provider/provider.dart';

import '../mocked_network_image_provider.dart';

void main() {
  testWidgets('HomeScreen implementation matches its design', (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      await tester.pumpWidget(wrappedHomeScreen());

      expect(find.byType(HomeHeader), findsOneWidget);
      expect(find.byType(SearchBar), findsOneWidget);
      expect(find.byType(HomeCTATile), findsOneWidget);
    });
  });
}

Widget wrappedHomeScreen() {
  var appState = AppState();
  appState.setCurrentUser(User());
  return ChangeNotifierProvider(
    create: (context) => appState,
    child: MaterialApp(home: HomeScreen()),
  );
}
