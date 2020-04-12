import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodieapp/models/app_state.dart';
import 'package:foodieapp/tabs/browse_tab_navigator.dart';
import 'package:foodieapp/widgets/tabs_bar.dart';
import 'package:provider/provider.dart';

final appState = AppState();

void main() {
  testWidgets('TabsBar updates route and state on tab switch',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrappedTabsBar());

    await tester.tap(find.byKey(Key('tab_browse')));
    await tester.pump();

    expect(appState.selectedTab, BrowseTabNavigator.id);
  });
}

Widget wrappedTabsBar() {
  return ChangeNotifierProvider(
    create: (context) => appState,
    child: MaterialApp(
      home: Scaffold(
        body: TabsBar(),
      ),
    ),
  );
}
