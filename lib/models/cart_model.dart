import 'package:flutter/foundation.dart';
import 'package:sandwich_shop/models/cart.dart' as base_cart;
import 'package:sandwich_shop/models/sandwich.dart';

/// A ChangeNotifier wrapper around the plain `Cart` model.
class CartModel extends ChangeNotifier {
  final base_cart.Cart _cart = base_cart.Cart();

  List<base_cart.CartItem> get items => _cart.items;

  int get totalItems => _cart.totalItems;

  double get totalPrice => _cart.totalPrice;

  bool get isEmpty => _cart.totalItems == 0;

  void add(Sandwich sandwich, {int quantity = 1}) {
    _cart.add(sandwich, quantity: quantity);
    notifyListeners();
  }

  void decrease(Sandwich sandwich, {int quantity = 1}) {
    _cart.decrease(sandwich, quantity: quantity);
    notifyListeners();
  }

  void clear() {
    _cart.clearAndLoadFrom(base_cart.Cart());
    notifyListeners();
  }

  base_cart.Cart get cart => _cart;
}
