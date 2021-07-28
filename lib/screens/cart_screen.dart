import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/card_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Consumer<Cart>(
        builder: (_, cart, __) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (ctx, i) => CartItems(
                  cart.items.values.toList()[i].title,
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].imageUrl,
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 4,
              margin: EdgeInsets.all(12),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListTile(
                        visualDensity: VisualDensity(
                          horizontal: 0,
                          vertical: -4,
                        ),
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          'Total :',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                        subtitle: Text(
                          '\$${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      color: Theme.of(context).accentColor,
                      onPressed: () {},
                      child: Text(
                        'Place Order',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .title
                                ?.color),
                      ),
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
