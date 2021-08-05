import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token = '';
  DateTime? _expiry = DateTime.now();
  String _userId = '';

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiry != null && _expiry!.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlPart) async {
    Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlPart?key=AIzaSyC0EJORHwhrOSA_-cLybe308fvhzCyjHig');
    try {
      final res = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      var resData = json.decode(res.body);
      if (resData['error'] != null) {
        throw HttpException(resData['error']['message']);
      }
      _token = resData['idToken'];
      _userId = resData['localId'];
      _expiry = DateTime.now().add(
        Duration(
          seconds: int.parse(
            resData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> login(String email, String password) async {
    await _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signup(String email, String password) async {
    await _authenticate(email, password, 'signUp');
  }
}
