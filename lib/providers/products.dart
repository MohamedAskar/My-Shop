import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';
import 'dart:convert';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    // title: 'Round Basic T-Shirt Red',
    // price: 29.99,
    // seller: 'Ravin',
    // imageUrl:
    //     'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // isFavorite: false,
    // discount: 10.0,
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Straight Fit Jeans Trousers',
    //   price: 59.99,
    //   seller: 'Pull and Bear',
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   isFavorite: false,
    //   discount: 0.0,
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Cotton Handmade Scarf Yellow',
    //   price: 19.99,
    //   seller: 'H&M',
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   isFavorite: false,
    //   discount: 0.0,
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Tefal Cooking Pan Black',
    //   price: 49.99,
    //   seller: 'Tefal',
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   isFavorite: false,
    //   discount: 0.0,
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findbyId(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  final String authToken;
  final String userId;

  Products(this.authToken, this._items, this.userId);

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://the-shop-c6485.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      if (extractedData == null) {
        return;
      }
      url =
          'https://the-shop-c6485.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(Product(
          id: prodId,
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          seller: prodData['seller'],
          title: prodData['title'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          discount: prodData['discount'],
        ));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://the-shop-c6485.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'seller': product.seller,
          'discount': product.discount,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          imageUrl: product.imageUrl,
          isFavorite: product.isFavorite,
          price: product.price,
          seller: product.seller,
          title: product.title,
          discount: product.discount);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((product) => product.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://the-shop-c6485.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'seller': newProduct.seller,
            'isFavorite': newProduct.isFavorite,
            'discount': newProduct.discount,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://the-shop-c6485.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete this product.');
    }
    existingProduct = null;
  }
}
