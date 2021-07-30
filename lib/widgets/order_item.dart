import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart';

class OrdItem extends StatefulWidget {
  final OrderItem order;

  OrdItem(this.order);

  @override
  _OrdItemState createState() => _OrdItemState();
}

class _OrdItemState extends State<OrdItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              '\$ ${widget.order.amount}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy  hh:mm').format(
                widget.order.dateTime,
              ),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              height: min(
                widget.order.products.length * 72.0,
                MediaQuery.of(context).size.height * 0.32,
              ),
              child: ListView(
                children: widget.order.products
                    .map(
                      (prod) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: FittedBox(
                              child: Image.network(prod.imageUrl.toString())),
                        ),
                        title: Text('${prod.title}    ${prod.quantity}x'),
                        subtitle: Text('\$ ${prod.price.toStringAsFixed(2)}'),
                        trailing: Text(
                          '\$ ${prod.price * prod.quantity}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
