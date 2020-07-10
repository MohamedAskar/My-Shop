import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String seller;
  bool isFavorite;
  double discount = 0.0;

  Product(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.imageUrl,
      @required this.seller,
      @required this.isFavorite,
      this.discount});

  Future<void> toggleFavorite(String token, String userId) async {
    final oldStatus = isFavorite;
    final url =
        'https://the-shop-c6485.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';

    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
