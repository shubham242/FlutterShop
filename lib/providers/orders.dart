import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
    this.id,
    this.amount,
    this.products,
    this.dateTime,
  );
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    Uri url = Uri.parse(
        'https://shop-app-af659-default-rtdb.firebaseio.com/orders.json');
    final res = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final data = json.decode(res.body) as Map<String, dynamic>?;
    if (data == null) return;
    data.forEach((orderId, value) {
      loadedOrders.add(
        OrderItem(
          orderId,
          value['amount'],
          (value['products'] as List<dynamic>)
              .map(
                (e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price'],
                  imageUrl: e['imageUrl'],
                ),
              )
              .toList(),
          DateTime.parse(value['dateTime']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    Uri url = Uri.parse(
        'https://shop-app-af659-default-rtdb.firebaseio.com/orders.json');
    final timeStamp = DateTime.now();
    final res = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                    'imageUrl': e.imageUrl,
                  })
              .toList(),
        },
      ),
    );
    _orders.insert(
        0,
        OrderItem(
          json.decode(res.body)['name'],
          total,
          cartProducts,
          DateTime.now(),
        ));
    notifyListeners();
  }
}
