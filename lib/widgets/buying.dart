import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class Buying extends StatelessWidget {
  Widget buildBtn(
    BuildContext context,
    Color? color,
    Color textColor,
    String title,
    Function press,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5 - 14,
      child: RaisedButton(
        color: color,
        child: FittedBox(
            child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )),
        onPressed: () => press(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Consumer<Product>(
          builder: (_, ctx, __) => buildBtn(
            context,
            Colors.grey[300],
            Colors.black,
            ctx.isFav ? 'Remove from Favorites' : 'Add to Favorites',
            () {
              ctx.toggleFav(authData.token, authData.userId);
            },
          ),
        ),
        buildBtn(
          context,
          Theme.of(context).accentColor,
          Colors.white,
          'Add to Cart',
          () {
            cart.addItem(
              product.id,
              product.price,
              product.title,
              product.imageUrl,
            );
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
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
        )
      ],
    );
  }
}
