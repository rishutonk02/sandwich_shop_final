import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/view_models/order_view_model.dart';
import 'package:sandwich_shop/services/file_service.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart_model.dart';
import 'package:sandwich_shop/views/app_drawer.dart';
import 'package:sandwich_shop/views/profile_screen.dart';

class OrderScreen extends StatefulWidget {
  final int maxQuantity;
  const OrderScreen({super.key, required this.maxQuantity});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  final Cart _cart = Cart();
  late final OrderViewModel _vm;
  final TextEditingController _notesController = TextEditingController();
  String? _confirmationMessage;

  SandwichType _selectedSandwichType = SandwichType.veggieDelight;
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _notesController.addListener(() {
      setState(() {});
    });
    _vm = OrderViewModel(cart: _cart, fileService: FileService());
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _addToCart() {
    if (_quantity > 0) {
      final Sandwich sandwich = Sandwich(
        type: _selectedSandwichType,
        isFootlong: _isFootlong,
        breadType: _selectedBreadType,
      );

      // Persist via view model
      _vm.addToCart(sandwich, quantity: _quantity);
      // Update shared in-memory cart so UI updates immediately
      try {
        Provider.of<CartModel>(
          context,
          listen: false,
        ).add(sandwich, quantity: _quantity);
      } catch (_) {}

      setState(() {});

      String sizeText = _isFootlong ? 'footlong' : 'six-inch';
      String confirmationMessage =
          'Added $_quantity $sizeText ${sandwich.name} sandwich(es) on ${_selectedBreadType.name} bread to cart';

      setState(() {
        _confirmationMessage = confirmationMessage;
      });
    }
  }

  void _addToCartWithFeedback() {
    _addToCart();
    // Persist cart so CartScreen can load the updated contents.
    _vm
        .saveCart('cart.json')
        .then((_) {
          debugPrint('OrderScreen: cart saved');
        })
        .catchError((e) {
          debugPrint('OrderScreen: failed to save cart: $e');
        });

    if (_confirmationMessage != null) {
      debugPrint('OrderScreen: $_confirmationMessage');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_confirmationMessage!),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      debugPrint('OrderScreen: addToCart called but no confirmation message');
    }
  }

  VoidCallback? _getAddToCartCallback() {
    if (_quantity > 0) {
      return _addToCartWithFeedback;
    }
    return null;
  }

  Future<void> _saveCart() async {
    await _vm.saveCart('cart.json');
    setState(() {
      _confirmationMessage = 'Cart saved';
    });
  }

  Future<void> _loadCart() async {
    final ok = await _vm.loadCart('cart.json');
    setState(() {
      _confirmationMessage = ok ? 'Cart loaded' : 'No saved cart found';
    });
  }

  List<DropdownMenuEntry<SandwichType>> _buildSandwichTypeEntries() {
    List<DropdownMenuEntry<SandwichType>> entries = [];
    for (SandwichType type in SandwichType.values) {
      Sandwich sandwich = Sandwich(
        type: type,
        isFootlong: true,
        breadType: BreadType.white,
      );
      DropdownMenuEntry<SandwichType> entry = DropdownMenuEntry<SandwichType>(
        value: type,
        label: sandwich.name,
      );
      entries.add(entry);
    }
    return entries;
  }

  List<DropdownMenuEntry<BreadType>> _buildBreadTypeEntries() {
    List<DropdownMenuEntry<BreadType>> entries = [];
    for (BreadType bread in BreadType.values) {
      DropdownMenuEntry<BreadType> entry = DropdownMenuEntry<BreadType>(
        value: bread,
        label: bread.name,
      );
      entries.add(entry);
    }
    return entries;
  }

  String _getCurrentImagePath() {
    final Sandwich sandwich = Sandwich(
      type: _selectedSandwichType,
      isFootlong: _isFootlong,
      breadType: _selectedBreadType,
    );
    return sandwich.image;
  }

  void _onSandwichTypeChanged(SandwichType? value) {
    if (value != null) {
      setState(() {
        _selectedSandwichType = value;
      });
    }
  }

  void _onSizeChanged(bool value) {
    setState(() {
      _isFootlong = value;
    });
  }

  void _onBreadTypeChanged(BreadType? value) {
    if (value != null) {
      setState(() {
        _selectedBreadType = value;
      });
    }
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  VoidCallback? _getDecreaseCallback() {
    if (_quantity > 0) {
      return _decreaseQuantity;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Sandwich Counter', style: AppStyles.heading1),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Show only the currently selected sandwich image
              SizedBox(
                height: 300,
                child: Image.asset(
                  _getCurrentImagePath(),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text(
                        'Image not found',
                        style: AppStyles.normalText,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Profile button
              StyledButton(
                onPressed: _navigateToProfile,
                icon: Icons.person,
                label: 'Profile',
                backgroundColor: Colors.purple,
              ),
              DropdownMenu<SandwichType>(
                width: double.infinity,
                label: const Text('Sandwich Type'),
                textStyle: AppStyles.normalText,
                initialSelection: _selectedSandwichType,
                onSelected: _onSandwichTypeChanged,
                dropdownMenuEntries: _buildSandwichTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Six-inch', style: AppStyles.normalText),
                  Switch(
                    key: const Key('size_switch'),
                    value: _isFootlong,
                    onChanged: _onSizeChanged,
                  ),
                  const Text('Footlong', style: AppStyles.normalText),
                ],
              ),
              const SizedBox(height: 20),
              DropdownMenu<BreadType>(
                width: double.infinity,
                label: const Text('Bread Type'),
                textStyle: AppStyles.normalText,
                initialSelection: _selectedBreadType,
                onSelected: _onBreadTypeChanged,
                dropdownMenuEntries: _buildBreadTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Quantity: ', style: AppStyles.normalText),
                  IconButton(
                    onPressed: _getDecreaseCallback(),
                    icon: const Icon(Icons.remove, color: Colors.black),
                    tooltip: 'Decrease quantity',
                  ),
                  Text('$_quantity', style: AppStyles.heading2),
                  IconButton(
                    onPressed: _increaseQuantity,
                    icon: const Icon(Icons.add, color: Colors.black),
                    tooltip: 'Increase quantity',
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
              const SizedBox(height: 12),
              // Confirmation message
              if (_confirmationMessage != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    _confirmationMessage!,
                    key: const Key('confirmation_text'),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              // Cart summary
              CartSummary(cart: _vm.cart),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledButton(
                    onPressed: _saveCart,
                    icon: Icons.save,
                    label: 'Save Cart',
                    backgroundColor: Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  StyledButton(
                    onPressed: _loadCart,
                    icon: Icons.folder_open,
                    label: 'Load Cart',
                    backgroundColor: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: AppStyles.normalText),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(backgroundColor),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}
