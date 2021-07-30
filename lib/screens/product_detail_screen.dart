import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/buying.dart';
import '../widgets/show_alert.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final product = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
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
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Card(
                color: Colors.white,
                elevation: 2,
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 20, right: 30),
                  title: Text(
                    product.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(product.description),
                  trailing: Container(
                    width: 20,
                    child: Consumer<Cart>(
                      builder: (cont, ctx, __) => IconButton(
                        padding: EdgeInsets.all(0),
                        icon: ctx.items.containsKey(product.id)
                            ? Icon(
                                Icons.shopping_cart,
                                size: 25,
                              )
                            : Icon(
                                Icons.shopping_cart_outlined,
                                size: 25,
                              ),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          cart.addItem(
                            product.id,
                            product.price,
                            product.title,
                            product.imageUrl,
                          );
                          Scaffold.of(cont).hideCurrentSnackBar();
                          Scaffold.of(cont).showSnackBar(
                            SnackBar(
                              content: Text('Item Added to Cart'),
                              duration: Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  cart.removeSingleItem(product.id);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 2,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.5,
                alignment: Alignment.center,
                child: Image.network(product.imageUrl),
              ),
            ),
            Card(
              elevation: 2,
              child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' \$${product.price.toString()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 5),
                    ChangeNotifierProvider.value(
                      value: product,
                      child: Buying(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
