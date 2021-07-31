import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItems extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final String imageUrl;

  CartItems(
    this.title,
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (_, ctx, __) => Dismissible(
        key: ValueKey(id),
        direction: DismissDirection.endToStart,
        background: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            padding: EdgeInsets.only(right: 20),
            alignment: Alignment.centerRight,
            color: Theme.of(context).errorColor,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        onDismissed: (direction) {
          Provider.of<Cart>(context, listen: false).removeItem(productId);
        },
        child: Card(
          margin: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            child: ListTile(
              leading: CircleAvatar(
                // backgroundColor: Colors.white,
                // child: FittedBox(child: Image.network(imageUrl.toString())),
                backgroundImage: NetworkImage(imageUrl),
              ),
              title: Text(title),
              subtitle:
                  Text('Total : \$${(price * quantity).toStringAsFixed(2)}'),
              trailing: Container(
                width: 80,
                height: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Qty :'),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          child: FittedBox(
                            child: FloatingActionButton(
                              heroTag: Text('bt1'),
                              shape: RoundedRectangleBorder(),
                              onPressed: () {
                                Provider.of<Cart>(context, listen: false)
                                    .decreaseItem(productId);
                              },
                              child: Icon(
                                Icons.remove,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '$quantity',
                          style: TextStyle(fontSize: 16),
                        ),
                        Container(
                          height: 20,
                          width: 20,
                          child: FittedBox(
                            child: Container(
                              child: FloatingActionButton(
                                heroTag: Text('bt2'),
                                shape: RoundedRectangleBorder(),
                                onPressed: () {
                                  Provider.of<Cart>(context, listen: false)
                                      .increaseItem(productId);
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
