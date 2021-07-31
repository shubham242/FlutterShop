import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './edit_screen.dart';
import '../widgets/user_product.dart';
import '../widgets/my_drawer.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProducts.routeName);
            },
          )
        ],
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.items.length,
          itemBuilder: (_, i) => UserProductItem(
            products.items[i].id,
            products.items[i].title,
            products.items[i].imageUrl,
            products.items[i].price,
          ),
        ),
      ),
    );
  }
}
