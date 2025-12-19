import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/cart_model.dart';

void main() {
  testWidgets('Cart item increment and decrement updates totals', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(create: (_) => CartModel(), child: const App()),
    );
    await tester.pumpAndSettle();

    // Add item (ensure visible)
    final addBtn = find.byKey(const Key('add_to_cart'));
    await tester.ensureVisible(addBtn);
    await tester.pumpAndSettle();
    await tester.tap(addBtn);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Go to cart
    final viewCart = find.text('View Cart');
    await tester.ensureVisible(viewCart);
    await tester.pumpAndSettle();
    await tester.tap(viewCart);
    await tester.pumpAndSettle();

    // Verify there is an item with quantity 1
    expect(find.textContaining('1x'), findsWidgets);

    // Tap the add (+) icon in the trailing row — find by icon
    final addIcon = find.byIcon(Icons.add_circle_outline).first;
    await tester.ensureVisible(addIcon);
    await tester.pumpAndSettle();
    await tester.tap(addIcon);
    await tester.pumpAndSettle();

    // Quantity should now be 2
    expect(find.textContaining('2x'), findsWidgets);

    // Tap the remove (-) icon
    final removeIcon = find.byIcon(Icons.remove_circle_outline).first;
    await tester.ensureVisible(removeIcon);
    await tester.pumpAndSettle();
    await tester.tap(removeIcon);
    await tester.pumpAndSettle();

    expect(find.textContaining('1x'), findsWidgets);
  });
}
