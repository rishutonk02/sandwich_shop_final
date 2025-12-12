import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Drawer navigation opens Cart and Settings', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Open drawer
    final Finder menu = find.byTooltip('Open navigation menu');
    expect(menu, findsOneWidget);
    await tester.tap(menu);
    await tester.pumpAndSettle();

    // Tap Cart
    final Finder cartTile = find.text('Cart');
    expect(cartTile, findsWidgets);
    await tester.tap(cartTile.first);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Cart screen should show items summary
    expect(find.textContaining('Items:'), findsOneWidget);

    // Open drawer again and tap Settings
    await tester.tap(menu);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    final Finder settingsTile = find.text('Settings');
    expect(settingsTile, findsWidgets);
    await tester.tap(settingsTile.first);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Settings screen shows the dark mode label
    expect(find.text('Enable Dark Mode'), findsOneWidget);
  });
}
