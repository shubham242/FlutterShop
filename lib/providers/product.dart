import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFav;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFav = false,
  });

  Future<void> toggleFav(String token, String userId) async {
    bool old = isFav;
    isFav = !isFav;
    notifyListeners();
    Uri url = Uri.parse(
        'https://shop-app-af659-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
    try {
      final res = await http.put(
        url,
        body: json.encode(isFav),
      );
      if (res.statusCode >= 400) {
        isFav = old;
        notifyListeners();
        throw Exception();
      }
    } catch (error) {
      isFav = old;
      notifyListeners();
      throw HttpException('Unable to mark as Favotite');
    }
    notifyListeners();
  }
}
