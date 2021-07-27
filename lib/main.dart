import 'package:flutter/material.dart';

import './screens/products_overview_screen.dart';
import './models/custom_colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
        primarySwatch: CustomColors.primaryColor,
        accentColor: CustomColors.accentColor,
        canvasColor: CustomColors.canvasColor,
        fontFamily: 'Lato',
      ),
      home: ProductsOverview(),
    );
  }
}
