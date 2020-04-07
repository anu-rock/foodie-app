import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Foodie App', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) driver.close();
    });

    // test('starts with home tab', () async {
    //   expect(await driver.getText(find.byType('Heading2')), 'Popular Recipes');
    // });

    test('allows searching for recipes', () async {
      await driver.runUnsynchronized(() async {
        final searchField = find.byValueKey('search_input');
        final textToType = 'Hello, Divya.';

        await driver.tap(searchField);
        await driver.enterText(textToType);
        await driver.waitFor(find.text(textToType));
      });

      // expect(await driver.getText(searchField), textToType);
    });

    test('updates route and state on tab switch', () async {
      await driver.tap(find.byValueKey('tab_browse'));

      expect(await driver.getText(find.byType('Text')), 'Browse');
    });
  });
}
