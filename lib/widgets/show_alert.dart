import 'package:flutter/material.dart';

showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    elevation: 10,
    backgroundColor: Colors.white.withOpacity(0.85),
    titlePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(
          Icons.check,
          size: 35,
        ),
        Text("Item Added to Cart"),
      ],
    ),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
