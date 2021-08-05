import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  final String authToken;
  Products(this.authToken, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((elem) => elem.isFav).toList();
  }

  Future<Null> fetchProducts() async {
    Uri url = Uri.parse(
        'https://shop-app-af659-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final res = await http.get(url);
      final data = json.decode(res.body) as Map<String, dynamic>?;
      final List<Product> prodList = [];
      if (data == null) return;

      data.forEach((prodId, value) {
        prodList.add(Product(
          id: prodId,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFav: value['isFav'],
        ));
      });
      _items = prodList;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<Null> addProduct(Product product) async {
    Uri url = Uri.parse(
        'https://shop-app-af659-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final res = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFav': product.isFav
        }),
      );

      final newProduct = Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print('error');
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);

    if (prodIndex >= 0) {
      Uri url = Uri.parse(
          'https://shop-app-af659-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      print(newProduct.title);
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    Uri url = Uri.parse(
        'https://shop-app-af659-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final tempProdIndex = _items.indexWhere((element) => element.id == id);
    var tempProd = _items[tempProdIndex];
    _items.removeAt(tempProdIndex);
    notifyListeners();
    final res = await http.delete(url);
    if (res.statusCode >= 400) {
      _items.insert(tempProdIndex, tempProd);
      notifyListeners();
      throw HttpException('Could not Delete product.');
    }
    tempProd.dispose();
  }

  Product findById(String id) {
    return _items.firstWhere((elem) => elem.id == id);
  }
}
