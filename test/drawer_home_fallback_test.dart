import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/cart_model.dart';

void main() {
  testWidgets('Drawer Home fallback pops to root when using Navigator', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(create: (_) => CartModel(), child: const App()),
    );
    await tester.pumpAndSettle();

    // Open drawer and navigate to About
    final menu = find.byTooltip('Open navigation menu');
    expect(menu, findsOneWidget);
    await tester.tap(menu);
    await tester.pumpAndSettle();

    final aboutTile = find.text('About');
    expect(aboutTile, findsWidgets);
    await tester.tap(aboutTile.first);
    await tester.pumpAndSettle();

    // We should be on About screen
    expect(find.textContaining('Welcome to Sandwich Shop'), findsOneWidget);

    // Open drawer and tap Home — should return to OrderScreen (root)
    await tester.tap(menu);
    await tester.pumpAndSettle();
    final homeTile = find.text('Home');
    expect(homeTile, findsWidgets);
    await tester.tap(homeTile.first);
    await tester.pumpAndSettle();

    expect(find.text('Sandwich Counter'), findsOneWidget);
  });
}
