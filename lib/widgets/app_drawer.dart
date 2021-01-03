import 'package:flutter/material.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import '../screens/orders_screen.dart';

class AppDrawar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Hello Friend"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            leading: const Icon(Icons.shop),
            title: const Text("Shop"),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
            },
            leading: Icon(Icons.payment),
            title: const Text("Your Orders"),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, UserProductsScreen.routeName);
            },
            leading: Icon(Icons.edit),
            title: const Text("Manage Products"),
          )
        ],
      ),
      elevation: 5,
    );
  }
}
