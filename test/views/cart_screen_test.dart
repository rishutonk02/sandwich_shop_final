import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/cart_screen_page.dart';
import 'package:sandwich_shop/models/cart_model.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  testWidgets('Cart screen shows empty state or items', (tester) async {
    final model = CartModel();
    // add two veggieDelight items to the in-memory cart
    model.add(
      Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      ),
      quantity: 2,
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: model,
        child: const MaterialApp(home: CartScreen()),
      ),
    );

    // Allow async load to proceed
    await tester.pumpAndSettle();

    // After loading, expect the Items label and our Veggie sandwich entry
    expect(find.textContaining('Items:'), findsOneWidget);
    expect(find.textContaining('Veggie Delight'), findsOneWidget);
  });
}
