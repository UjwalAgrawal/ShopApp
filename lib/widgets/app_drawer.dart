import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';
import '../providers/auth.dart';
import '../helpers/custom_route.dart';

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
              // Navigator.pushReplacement(
              //   context,
              //   CustomRoute(
              //     builder: (ctx) => OrdersScreen(),
              //   ),
              // );
            },
            leading: Icon(Icons.payment),
            title: const Text("Orders"),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, UserProductsScreen.routeName);
            },
            leading: Icon(Icons.edit),
            title: const Text("Manage Products"),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
              Provider.of<Auth>(context, listen: false).logout();
            },
            leading: Icon(Icons.logout),
            title: const Text("Logout?"),
          )
        ],
      ),
      elevation: 5,
    );
  }
}
