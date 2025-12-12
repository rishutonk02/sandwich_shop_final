import 'package:flutter/foundation.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

/// Lightweight ChangeNotifier wrapper around the existing Cart model.
class CartModel extends ChangeNotifier {
  final Cart _cart = Cart();

  List<CartItem> get items => _cart.items;

  int get totalItems => _cart.totalItems;

  double get totalPrice => _cart.totalPrice;

  Cart get cart => _cart;

  void add(Sandwich sandwich, {int quantity = 1}) {
    _cart.add(sandwich, quantity: quantity);
    notifyListeners();
  }

  bool decrease(Sandwich sandwich, {int quantity = 1}) {
    final changed = _cart.decrease(sandwich, quantity: quantity);
    if (changed) notifyListeners();
    return changed;
  }

  void clear() {
    // There's no public clear on Cart; use clearAndLoadFrom with empty cart
    _cart.clearAndLoadFrom(Cart());
    notifyListeners();
  }
}
