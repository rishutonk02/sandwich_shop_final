import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Add to cart shows confirmation SnackBar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Ensure quantity is 1 by default and tap Add to Cart
    final Finder addButton = find.byKey(const Key('add_to_cart'));
    expect(addButton, findsOneWidget);

    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();

    await tester.tap(addButton);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // SnackBar should be shown with confirmation text
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
