import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final String seller;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.price,
    @required this.seller,
    @required this.quantity,
  });
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

  int get totalQuantity {
    int subtotal = 0;
    _items.forEach((key, cartItem) {
      subtotal += cartItem.quantity;
    });
    return subtotal;
  }

  

  void addItem(String productId, double price, String title, String seller,
      String imageUrl, int quantityWanted) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                price: existingItem.price,
                title: existingItem.title,
                quantity: existingItem.quantity + quantityWanted,
                seller: existingItem.seller,
                imageUrl: existingItem.imageUrl,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: productId,
                price: price,
                title: title,
                quantity: quantityWanted,
                seller: seller,
                imageUrl: imageUrl,
              ));
    }
    notifyListeners();
  }


  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(
          id,
          (existingCardItem) => CartItem(
                id: existingCardItem.id,
                imageUrl: existingCardItem.imageUrl,
                price: existingCardItem.price,
                quantity: existingCardItem.quantity - 1,
                seller: existingCardItem.seller,
                title: existingCardItem.title,
              ));
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
