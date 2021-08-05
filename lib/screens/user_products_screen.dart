import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './edit_screen.dart';
import '../widgets/user_product.dart';
import '../widgets/my_drawer.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: _refresh(context),
        builder: (ctx, ss) => ss.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refresh(context),
                child: Consumer<Products>(
                  builder: (ctx, products, _) => Padding(
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
                ),
              ),
      ),
    );
  }
}
