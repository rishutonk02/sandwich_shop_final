import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:sandwich_shop/main.dart' as app;
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/common_widgets.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end tests', () {
    testWidgets('Add Veggie Delight to cart and verify', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);
    });

    testWidgets('Change sandwich type and add to cart', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final dropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('Modify quantity and add to cart', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Quantity:'), findsOneWidget);

      final plusButtons = find.byIcon(Icons.add);
      final quantityPlus = plusButtons.first;

      await tester.tap(quantityPlus);
      await tester.pumpAndSettle();
      await tester.tap(quantityPlus);
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);
    });

    testWidgets('Complete checkout flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);

      final confirmPayment = find.text('Confirm Payment');
      await tester.tap(confirmPayment);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 3));

      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });

    testWidgets('Remove item from cart', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      final deleteButton = find.byIcon(Icons.delete);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      expect(find.text('Total: £0.00'), findsOneWidget);
    });

    testWidgets('Decrease quantity but not below 1', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final minusButtons = find.byIcon(Icons.remove);
      final quantityMinus = minusButtons.first;

      await tester.tap(quantityMinus);
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Checkout with empty cart does not crash', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);
    });

    testWidgets('Navigate back from checkout to cart', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);
    });

    testWidgets('Change type + quantity then add to cart', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final dropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      final plusButtons = find.byIcon(Icons.add);
      final quantityPlus = plusButtons.first;

      await tester.tap(quantityPlus);
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 2 items - £22.00'), findsOneWidget);
    });
  });
}
