import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      //change quantity
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              quantity: existingCartItem.quantity + 1,
              title: title,
              price: price));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              quantity: 1,
              title: title,
              price: price));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    // _items.removeWhere((key, cartItem) => cartItem.id == id);
    _items.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (cartItem) => CartItem(
              id: cartItem.id,
              title: cartItem.title,
              price: cartItem.price,
              quantity: cartItem.quantity - 1));
    } else {
      _items.remove(productId);
    }

    ///important to update the state of the listening UI which here is our cart badge
    notifyListeners();

  }
}
