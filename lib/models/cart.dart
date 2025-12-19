import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CartItem {
  final Sandwich sandwich;
  int quantity;

  CartItem({required this.sandwich, required this.quantity});
}

class Cart {
  final List<CartItem> _items = [];
  final PricingRepository _pricing = PricingRepository();

  void add(Sandwich sandwich, {int quantity = 1}) {
    final existing = _items.firstWhere(
      (it) =>
          it.sandwich.type == sandwich.type &&
          it.sandwich.isFootlong == sandwich.isFootlong &&
          it.sandwich.breadType == sandwich.breadType,
      orElse: () => CartItem(sandwich: sandwich, quantity: 0),
    );

    if (existing.quantity == 0) {
      _items.add(CartItem(sandwich: sandwich, quantity: quantity));
    } else {
      existing.quantity += quantity;
    }
  }

  /// Decrease quantity of [sandwich] by [quantity]. If quantity becomes
  /// zero or less the item is removed. Returns true if an item was updated
  /// or removed, false if the sandwich was not found.
  bool decrease(Sandwich sandwich, {int quantity = 1}) {
    final index = _items.indexWhere(
      (it) =>
          it.sandwich.type == sandwich.type &&
          it.sandwich.isFootlong == sandwich.isFootlong &&
          it.sandwich.breadType == sandwich.breadType,
    );
    if (index == -1) return false;
    final it = _items[index];
    if (quantity >= it.quantity) {
      _items.removeAt(index);
    } else {
      it.quantity -= quantity;
    }
    return true;
  }

  int get totalItems {
    int sum = 0;
    for (final it in _items) {
      sum += it.quantity;
    }
    return sum;
  }

  double get totalPrice {
    double total = 0.0;
    for (final it in _items) {
      total += _pricing.calculateTotal(
        quantity: it.quantity,
        isFootlong: it.sandwich.isFootlong,
      );
    }
    return total;
  }

  List<CartItem> get items => List.unmodifiable(_items);

  Map<String, dynamic> toJson() {
    return {
      'items': _items
          .map(
            (it) => {
              'type': it.sandwich.type.name,
              'isFootlong': it.sandwich.isFootlong,
              'bread': it.sandwich.breadType.name,
              'quantity': it.quantity,
            },
          )
          .toList(),
    };
  }

  static Cart fromJson(Map<String, dynamic> json) {
    final cart = Cart();
    final items = json['items'] as List<dynamic>? ?? [];
    for (final item in items) {
      final typeName = item['type'] as String;
      final isFootlong = item['isFootlong'] as bool;
      final breadName = item['bread'] as String;
      final quantity = item['quantity'] as int;

      final type = SandwichType.values.firstWhere((e) => e.name == typeName);
      final bread = BreadType.values.firstWhere((e) => e.name == breadName);

      final sandwich = Sandwich(
        type: type,
        isFootlong: isFootlong,
        breadType: bread,
      );
      cart.add(sandwich, quantity: quantity);
    }
    return cart;
  }

  void clearAndLoadFrom(Cart other) {
    _items.clear();
    for (final it in other.items) {
      _items.add(CartItem(sandwich: it.sandwich, quantity: it.quantity));
    }
  }
}
