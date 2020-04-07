import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodieapp/models/app_state.dart';
import 'package:foodieapp/screens/home/home_screen.dart';
import 'package:foodieapp/screens/home/home_header.dart';
import 'package:foodieapp/screens/home/search_bar.dart';
import 'package:foodieapp/screens/home/home_cta_tile.dart';
import 'package:foodieapp/widgets/tabs_bar.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('HomeScreen implementation matches its design',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrappedHomeScreen());

    expect(find.byType(HomeHeader), findsOneWidget);
    expect(find.byType(SearchBar), findsOneWidget);
    expect(find.byType(HomeCTATile), findsOneWidget);
    expect(find.byType(TabsBar), findsOneWidget);
  });
}

Widget wrappedHomeScreen() {
  var appState = AppState();
  return ChangeNotifierProvider(
    create: (context) => appState,
    child: MaterialApp(home: HomeScreen()),
  );
}
