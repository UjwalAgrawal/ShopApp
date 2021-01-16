import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName,
                    arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text(
                      "Are you sure to delete?",
                      style: TextStyle(fontSize: 15),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          try {
                            await Provider.of<Products>(context, listen: false)
                                .deleteProduct(id);
                          } catch (e) {
                            scaffold.showSnackBar(SnackBar(
                                content: Text(
                              "Deleting failed!",
                              textAlign: TextAlign.center,
                            )));
                          }
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Yes",
                          textAlign: TextAlign.end,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "No",
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                );
              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
