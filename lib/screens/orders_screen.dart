import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart' as oi;

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future _obtainOrders() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("rebuilded");
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawar(),
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapshot.error != null) {
            return Center(
              child: Text("An error occured"),
            );
          } else {
            return Consumer<Orders>(
              builder: (context, orderData, child) => ListView.builder(
                itemBuilder: (ctx, i) => oi.OrderItem(
                  orderData.orders[i],
                ),
                itemCount: orderData.orders.length,
              ),
            );
          }
        },
      ),
    );
  }
}
