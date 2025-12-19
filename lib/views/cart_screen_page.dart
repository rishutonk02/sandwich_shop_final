import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
import 'package:sandwich_shop/views/app_drawer.dart';
import 'package:sandwich_shop/models/cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _navigateToCheckout(
    BuildContext context,
    CartModel cartModel,
  ) async {
    if (cartModel.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty')));
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CheckoutScreen(cart: cartModel.cart)),
    );

    if (result != null && context.mounted) {
      // clear cart after successful checkout
      cartModel.clear();
      final orderId = result['orderId'] as String? ?? 'UNKNOWN';
      final estimatedTime = result['estimatedTime'] as String? ?? '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order $orderId confirmed! Estimated: $estimatedTime'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Cart', style: AppStyles.heading1)),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Items: ${cartModel.totalItems}',
              key: const Key('cart_items'),
              style: AppStyles.normalText,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: cartModel.items.length,
                itemBuilder: (context, index) {
                  final it = cartModel.items[index];
                  return ListTile(
                    title: Text(
                      '${it.quantity}x ${it.sandwich.name}',
                      style: AppStyles.normalText,
                    ),
                    subtitle: Text(
                      '${it.sandwich.breadType.name} • ${it.sandwich.isFootlong ? 'Footlong' : 'Six-inch'}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: it.quantity > 0 ? Colors.black : Colors.grey,
                          ),
                          onPressed: it.quantity > 0
                              ? () {
                                  cartModel.decrease(it.sandwich, quantity: 1);
                                }
                              : null,
                        ),
                        Text('${it.quantity}', style: AppStyles.normalText),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            cartModel.add(it.sandwich, quantity: 1);
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '£${PricingRepository().calculateTotal(quantity: it.quantity, isFootlong: it.sandwich.isFootlong).toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Total: £${cartModel.totalPrice.toStringAsFixed(2)}',
              key: const Key('cart_total'),
              style: AppStyles.heading2,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _navigateToCheckout(context, cartModel),
              icon: const Icon(Icons.payment),
              label: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
