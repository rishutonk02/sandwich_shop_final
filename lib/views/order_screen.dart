import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart_model.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/profile_screen.dart';
import 'package:sandwich_shop/views/settings_screen.dart';
import 'package:sandwich_shop/views/app_drawer.dart';
// Order history screen not implemented in this worksheet. Navigate shows a message.
import 'package:sandwich_shop/views/common_widgets.dart';
import 'package:sandwich_shop/firebase_example.dart';
import 'package:sandwich_shop/views/firebase_orders_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key, required this.maxQuantity});
  final int maxQuantity;

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController _notesController = TextEditingController();
  SandwichType _selectedSandwichType = SandwichType.veggieDelight;
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _notesController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _navigateToProfile() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
    if (result != null && mounted) {
      final name = result['name']!;
      final location = result['location']!;
      final msg = 'Welcome, $name! Ordering from $location';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 3)),
      );
    }
  }

  void _navigateToCartView() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  void _navigateToOrderHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order history not implemented yet')),
    );
  }

  Future<void> _runFirebaseDemo() async {
    final example = FirebaseExample();
    try {
      final cred = await example.signInAnonymously();
      await example.addOrder({
        'item': 'Demo Sandwich',
        'created_at': DateTime.now().toIso8601String(),
        'uid': cred.user?.uid ?? 'unknown',
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Firebase demo: signed in & order created'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Firebase demo failed: $e')));
    }
  }

  void _addToCart() {
    if (_quantity > 0) {
      final sandwich = Sandwich(
        type: _selectedSandwichType,
        isFootlong: _isFootlong,
        breadType: _selectedBreadType,
      );
      final cart = Provider.of<CartModel>(context, listen: false);
      cart.add(sandwich, quantity: _quantity);

      final sizeText = _isFootlong ? 'footlong' : 'six-inch';
      final msg =
          'Added $_quantity $sizeText ${sandwich.name} sandwich(es) on ${_selectedBreadType.name} bread';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
      );
    }
  }

  VoidCallback? _getAddToCartCallback() {
    if (_quantity > 0 && _quantity <= widget.maxQuantity) return _addToCart;
    return null;
  }

  List<DropdownMenuEntry<SandwichType>> _buildSandwichTypeEntries() {
    return SandwichType.values
        .map(
          (type) => DropdownMenuEntry<SandwichType>(
            value: type,
            label: Sandwich(
              type: type,
              isFootlong: true,
              breadType: BreadType.white,
            ).name,
          ),
        )
        .toList();
  }

  List<DropdownMenuEntry<BreadType>> _buildBreadTypeEntries() {
    return BreadType.values
        .map(
          (bread) =>
              DropdownMenuEntry<BreadType>(value: bread, label: bread.name),
        )
        .toList();
  }

  String _getCurrentImagePath() {
    final s = Sandwich(
      type: _selectedSandwichType,
      isFootlong: _isFootlong,
      breadType: _selectedBreadType,
    );
    return s.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShopAppBar(title: 'Sandwich Counter'),
      drawer: const AppDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 300,
                child: Image.asset(
                  _getCurrentImagePath(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Center(child: Text('Image not found', style: normalText)),
                ),
              ),
              const SizedBox(height: 20),
              DropdownMenu<SandwichType>(
                width: double.infinity,
                label: Text('Sandwich Type', style: normalText),
                textStyle: normalText,
                initialSelection: _selectedSandwichType,
                onSelected: (value) {
                  if (value != null) {
                    setState(() => _selectedSandwichType = value);
                  }
                },
                dropdownMenuEntries: _buildSandwichTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Six-inch', style: normalText),
                  Switch(
                    key: const Key('size_switch'),
                    value: _isFootlong,
                    onChanged: (value) => setState(() => _isFootlong = value),
                  ),
                  Text('Footlong', style: normalText),
                ],
              ),
              const SizedBox(height: 20),
              DropdownMenu<BreadType>(
                width: double.infinity,
                label: Text('Bread Type', style: normalText),
                textStyle: normalText,
                initialSelection: _selectedBreadType,
                onSelected: (value) {
                  if (value != null) setState(() => _selectedBreadType = value);
                },
                dropdownMenuEntries: _buildBreadTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Quantity: ', style: normalText),
                  IconButton(
                    onPressed: _quantity > 0
                        ? () => setState(() => _quantity--)
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$_quantity', style: heading2),
                  IconButton(
                    onPressed: _quantity < widget.maxQuantity
                        ? () => setState(() => _quantity++)
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StyledButton(
                key: const Key('add_to_cart'),
                onPressed: _getAddToCartCallback(),
                icon: Icons.add_shopping_cart,
                label: 'Add to Cart',
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 20),
              // Confirmation message removed: feedback is shown via SnackBar.
              StyledButton(
                onPressed: _navigateToCartView,
                icon: Icons.shopping_cart,
                label: 'View Cart',
                backgroundColor: Colors.blue,
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _navigateToProfile,
                icon: Icons.person,
                label: 'Profile',
                backgroundColor: Colors.purple,
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _navigateToSettings,
                icon: Icons.settings,
                label: 'Settings',
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _navigateToOrderHistory,
                icon: Icons.history,
                label: 'Order History',
                backgroundColor: Colors.indigo,
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _runFirebaseDemo,
                icon: Icons.cloud,
                label: 'Firebase Demo',
                backgroundColor: Colors.teal,
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FirebaseOrdersScreen(),
                    ),
                  );
                },
                icon: Icons.list,
                label: 'Show Orders',
                backgroundColor: Colors.orange,
              ),
              const SizedBox(height: 20),
              Consumer<CartModel>(
                builder: (context, cart, child) => Column(
                  children: [
                    Text(
                      'Items: ${cart.totalItems}',
                      key: const Key('cart_items'),
                      style: normalText,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total: £${cart.totalPrice.toStringAsFixed(2)}',
                      key: const Key('cart_total'),
                      style: normalText,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
