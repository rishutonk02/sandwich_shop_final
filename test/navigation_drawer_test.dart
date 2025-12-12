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
  });
}
