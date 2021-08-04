import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart';
import '../widgets/my_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        drawer: MyDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchOrders(),
          builder: (ctx, dataSS) {
            if (dataSS.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSS.error == null) {
                return Consumer<Orders>(
                    builder: (ctx, ordersData, child) => ListView.builder(
                        itemCount: ordersData.orders.length,
                        itemBuilder: (ctx, i) =>
                            OrdItem(ordersData.orders[i])));
              }
            }
            return Container();
          },
        ));
  }
}
