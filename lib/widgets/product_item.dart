import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ProductDetail.routeName,
                  arguments: product.id,
                );
              },
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            footer: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              child: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '\$ ${product.price}',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                trailing: Container(
                  width: 20,
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.shopping_cart,
                      size: 20,
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          height: 30,
          top: 5,
          right: -10,
          child: Container(
            child: Consumer<Product>(
              builder: (ctx, product, _) => FloatingActionButton(
                backgroundColor: Theme.of(context).canvasColor,
                child: Icon(
                  Icons.favorite,
                  color: product.isFav ? Colors.red : Colors.grey[350],
                  size: 25,
                ),
                onPressed: () {
                  product.toggleFav();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
