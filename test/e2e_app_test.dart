import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_shop/main.dart' as app;

void main() {
  testWidgets('simple end-to-end: add default sandwich and view cart', (
    WidgetTester tester,
  ) async {
    // Pump the App widget directly in the test environment
    await tester.pumpWidget(const app.App());
    await tester.pumpAndSettle();

    // App root is visible
    expect(find.text('Sandwich Counter'), findsOneWidget);

    // Initially cart shows 0 items in the order screen summary
    expect(find.textContaining('Items:'), findsWidgets);
    expect(find.text('Items: 0'), findsOneWidget);

    // Tap Add to Cart
    final addBtn = find.byKey(const Key('add_to_cart'));
    expect(addBtn, findsOneWidget);
    await tester.ensureVisible(addBtn);
    await tester.tap(addBtn);
    await tester.pumpAndSettle();

    // Cart summary increments
    expect(find.text('Items: 1'), findsOneWidget);

    // Navigate to Cart
    final viewCart = find.text('View Cart');
    expect(viewCart, findsOneWidget);
    await tester.ensureVisible(viewCart);
    await tester.tap(viewCart);
    await tester.pumpAndSettle();

    // Cart screen shows the item and total
    expect(find.text('Cart'), findsOneWidget);
    expect(find.textContaining('Veggie Delight'), findsWidgets);
    expect(find.textContaining('Total:'), findsOneWidget);
  });
}
