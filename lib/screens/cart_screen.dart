import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './orders_screen.dart';
import '../providers/orders.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$${cart.totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => CartItem(
                  id: cart.items.values.toList()[index].id,
                  productId: cart.items.keys.toList()[index],
                  title: cart.items.values.toList()[index].title,
                  quantity: cart.items.values.toList()[index].quantity,
                  price: cart.items.values.toList()[index].price),
              itemCount: cart.noOfItems,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          )
        : TextButton(
            onPressed: widget.cart.totalAmount <= 0
                ? null
                : () async {
                    if (widget.cart.totalAmount != 0) {
                      setState(() {
                        _isLoading = true;
                      });
                      await Provider.of<Orders>(context, listen: false)
                          .addOrder(
                        widget.cart.items.values.toList(),
                        widget.cart.totalAmount,
                      )
                          .catchError((_) {
                        setState(() {
                          _isLoading = false;
                        });
                      });
                      setState(() {
                        _isLoading = false;
                      });
                      widget.cart.clear();
                      Navigator.pushNamed(context, OrdersScreen.routeName);
                    }
                  },
            child: Text(
              "ORDER NOW",
              style: TextStyle(
                  color: widget.cart.totalAmount <= 0
                      ? Colors.grey
                      : Theme.of(context).primaryColor),
            ),
          );
  }
}
