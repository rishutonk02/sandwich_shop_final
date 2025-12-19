import 'package:flutter_test/flutter_test.dart'
    show
        Finder,
        WidgetTester,
        expect,
        find,
        findsOneWidget,
        findsWidgets,
        testWidgets;
import 'package:provider/provider.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/cart_model.dart';

void main() {
  testWidgets('Drawer navigation opens Cart and Settings', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(create: (_) => CartModel(), child: const App()),
    );
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

    // Open drawer and tap Profile
    await tester.tap(menu);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final Finder profileTile = find.text('Profile');
    expect(profileTile, findsWidgets);
    await tester.tap(profileTile.first);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Profile'), findsOneWidget);

    // Open drawer and tap About
    await tester.tap(menu);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final Finder aboutTile = find.text('About');
    expect(aboutTile, findsWidgets);
    await tester.tap(aboutTile.first);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.textContaining('Welcome to Sandwich Shop'), findsOneWidget);

    // Finally, open drawer and tap Home to return to OrderScreen
    await tester.tap(menu);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final Finder homeTile = find.text('Home');
    expect(homeTile, findsWidgets);
    await tester.tap(homeTile.first);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Sandwich Counter'), findsOneWidget);
  });
}
