import 'package:flutter/material.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://rukminim1.flixcart.com/image/808/970/kevpwnk0/trouser/y/h/v/34-ziks-black-casual-pant-fashlook-original-imafvgzw96ktxvhw.jpeg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://rukminim1.flixcart.com/image/416/416/kc29n680/pot-pan/h/8/a/ultra-non-stick-wonderchef-original-imaft95quypwumjr.jpeg',
    ),
  ];

  // bool _showFavoritesOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite == true).toList();
  }

  Product findById(String productId) {
    return _items.firstWhere((prod) => prod.id == productId);
  }

  void addProduct(Product product) {
    // _items.add(value);
    Product newProduct = Product(
        id: DateTime.now().toIso8601String(),
        imageUrl: product.imageUrl,
        title: product.title,
        description: product.description,
        price: product.price);
    _items.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else
      print("...");
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
