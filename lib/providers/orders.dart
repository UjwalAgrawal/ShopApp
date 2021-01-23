import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;
  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        "https://flutter-update-176d1-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    final response = await http.get(url);
    // print(json.decode(response.body));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData != null) {
      extractedData.forEach((orderID, orderData) {
        loadedOrders.insert(
          0,
          OrderItem(
            id: orderID,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ),
                )
                .toList(),
            dateTime: DateTime.parse(
              orderData['dateTime'],
            ),
          ),
        );
      });
    }
    // _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double totalAmount) async {
    final url =
        "https://flutter-update-176d1-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': totalAmount,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      "price": cp.price,
                      "quantity": cp.quantity,
                      "title": cp.title,
                    })
                .toList(),
          }));

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: totalAmount,
          products: cartProducts,
          dateTime: timeStamp,
        ),
      );
    } on Exception catch (_) {
      throw HttpException("Order placement failed");
    }
    notifyListeners();
  }
}
