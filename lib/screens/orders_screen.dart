import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart' as oi;

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawar(),
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) => oi.OrderItem(
          orderData.orders[i],
        ),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
