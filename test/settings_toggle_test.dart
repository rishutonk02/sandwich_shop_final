import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/theme_model.dart';
import 'package:sandwich_shop/models/cart_model.dart';

void main() {
  testWidgets('Settings toggle updates ThemeModel when provided', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartModel()),
          ChangeNotifierProvider(create: (_) => ThemeModel()),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    // Open drawer and navigate to Settings
    final menu = find.byTooltip('Open navigation menu');
    expect(menu, findsOneWidget);
    await tester.tap(menu);
    await tester.pumpAndSettle();

    final settingsTile = find.widgetWithText(ListTile, 'Settings');
    expect(settingsTile, findsWidgets);
    await tester.ensureVisible(settingsTile.first);
    await tester.pumpAndSettle();
    await tester.tap(settingsTile.first);
    await tester.pumpAndSettle();

    // The Switch should be enabled when ThemeModel is present
    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsWidgets);

    // There may be other switches in the app; pick the one visible on Settings.
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Enable Dark Mode'));
    await tester.pumpAndSettle();

    final Finder visibleSwitch = switchFinder.first;
    final Switch before = tester.widget<Switch>(visibleSwitch);
    await tester.ensureVisible(visibleSwitch);
    await tester.pumpAndSettle();
    await tester.tap(visibleSwitch);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    final Switch after = tester.widget<Switch>(visibleSwitch);
    expect(before.value != after.value, isTrue);
  });
}
