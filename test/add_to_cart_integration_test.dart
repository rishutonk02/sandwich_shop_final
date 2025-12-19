import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/cart_model.dart';

void main() {
  testWidgets('Add to cart updates cart and navigates to cart view', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(create: (_) => CartModel(), child: const App()),
    );
    await tester.pumpAndSettle();

    // Initially zero items
    expect(find.textContaining('Items:'), findsOneWidget);
    expect(find.text('Items: 0'), findsOneWidget);

    // Tap Add to Cart - ensure visible first
    final addBtn = find.byKey(const Key('add_to_cart'));
    expect(addBtn, findsOneWidget);
    await tester.ensureVisible(addBtn);
    await tester.pumpAndSettle();
    await tester.tap(addBtn);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Should show SnackBar and cart items incremented
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('Items: 1'), findsOneWidget);

    // Tap View Cart (button labeled 'View Cart')
    final viewCart = find.text('View Cart');
    expect(viewCart, findsOneWidget);
    await tester.ensureVisible(viewCart);
    await tester.pumpAndSettle();
    await tester.tap(viewCart);
    await tester.pumpAndSettle();

    // Cart screen should show item list and totals
    expect(find.text('Cart'), findsOneWidget);
    expect(find.textContaining('Items: 1'), findsOneWidget);
  });
}
