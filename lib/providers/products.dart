import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  // [
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://rukminim1.flixcart.com/image/808/970/kevpwnk0/trouser/y/h/v/34-ziks-black-casual-pant-fashlook-original-imafvgzw96ktxvhw.jpeg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://rukminim1.flixcart.com/image/416/416/kc29n680/pot-pan/h/8/a/ultra-non-stick-wonderchef-original-imaft95quypwumjr.jpeg',
  //   ),
  // ];

  // bool _showFavoritesOnly = false;

  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite == true).toList();
  }

  Product findById(String productId) {
    return _items.firstWhere((prod) => prod.id == productId);
  }

  Future<void> fetchAndSetProducts([bool filterbyUser = false]) async {
    final filterString =
        filterbyUser ? 'orderBy="creatorId"&equalTo="$userId"' : "";
    var url =
        'https://flutter-update-176d1-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      url =
          "https://flutter-update-176d1-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken";
      final favoriteResponse = await http.get(url);
      final favoriteData = jsonDecode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      if (extractedData != null) {
        extractedData.forEach((key, value) {
          loadedProducts.add(
            Product(
              id: key,
              title: value['title'],
              description: value["description"],
              imageUrl: value["imageUrl"],
              price: value["price"],
              isFavorite:
                  favoriteData == null ? false : favoriteData[key] ?? false,
            ),
          );
        });
        _items = loadedProducts;
      }

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    // _items.add(value);
    final url =
        'https://flutter-update-176d1-default-rtdb.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "creatorId": userId,
        }),
      );

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          imageUrl: product.imageUrl,
          title: product.title,
          description: product.description,
          price: product.price);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        final url =
            "https://flutter-update-176d1-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'price': newProduct.price,
              'description': newProduct.description,
              "imageUrl": newProduct.imageUrl,
            }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } on Exception catch (e) {
        throw e;
      }
    } else
      print("...");
  }

  Future<void> deleteProduct(String id) async {
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final url =
        "https://flutter-update-176d1-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      throw HttpException("Could not delete the product.");
    }
    existingProduct = null;
  }
}
