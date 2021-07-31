import 'package:flutter/material.dart';

import '../screens/edit_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double price;

  UserProductItem(this.title, this.imageUrl, this.price);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(title),
        subtitle: Text('Price: \$ ${price.toString()}'),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {},
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
