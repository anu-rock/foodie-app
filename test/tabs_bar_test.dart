import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodieapp/models/app_state.dart';
import 'package:foodieapp/screens/browse/browse_screen.dart';
import 'package:foodieapp/widgets/tabs_bar.dart';
import 'package:provider/provider.dart';

final appState = AppState();

void main() {
  testWidgets('TabsBar contains five tab buttons', (WidgetTester tester) async {
    await tester.pumpWidget(wrappedTabsBar());

    final semHandle = tester.ensureSemantics();

    expect(tester.getSemantics(find.byKey(Key('tab_hidden'))),
        matchesSemantics(isHidden: true));

    semHandle.dispose();
  });

  testWidgets('TabsBar updates route and state on tab switch',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrappedTabsBar());

    await tester.tap(find.byKey(Key('tab_browse')));
    await tester.pump();

    expect(appState.selectedTab, BrowseScreen.id);
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
