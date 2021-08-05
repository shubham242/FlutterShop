import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/orders.dart';
import '../screens/user_products_screen.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            visualDensity: VisualDensity(horizontal: 0.0, vertical: -4.0),
            leading: Icon(Icons.shop),
            title: Text(
              'Shop',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            visualDensity: VisualDensity(horizontal: 0.0, vertical: -4.0),
            leading: Icon(Icons.payment),
            title: Text(
              'Orders',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            visualDensity: VisualDensity(horizontal: 0.0, vertical: -4.0),
            leading: Icon(Icons.edit),
            title: Text(
              'Manage Products',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProducts.routeName);
            },
          ),
          Divider(),
          Spacer(),
          ListTile(
            visualDensity: VisualDensity(horizontal: 0.0, vertical: -4.0),
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}
