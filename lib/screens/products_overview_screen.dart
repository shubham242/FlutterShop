import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/my_drawer.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverview extends StatefulWidget {
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  bool _showFav = false;
  bool _isInit = true;
  bool _isLoad = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoad = true;
      Provider.of<Products>(context).fetchProducts().then((_) {
        setState(() {
          _isLoad = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch!,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.Favorites) {
                  _showFav = true;
                } else {
                  _showFav = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      body: _isLoad
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGridView(_showFav),
    );
  }
}
