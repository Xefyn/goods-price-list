import 'package:flutter/material.dart';
import 'package:goods_list_item/Screen/goodsList.dart';

void main() {
  runApp(GoodsPriceList());
}

class GoodsPriceList extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: GoodsList(),
    );
  }
}
