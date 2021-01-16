import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String description;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.imageUrl,
    @required this.title,
    @required this.description,
    @required this.price,
    this.isFavorite = false,
  });

  void _setFavStatus(bool oldStatus) {
    isFavorite = oldStatus;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        "https://flutter-update-176d1-default-rtdb.firebaseio.com/products/$id.json";
    try {
      final response = await http.patch(
        url,
        body: json.encode({"isFavorite": isFavorite}),
      );
      if (response.statusCode >= 400) {
        _setFavStatus(oldStatus);
        throw HttpException("Toggle failed");
      }
    } catch (e) {
      _setFavStatus(oldStatus);
    }
  }
}
