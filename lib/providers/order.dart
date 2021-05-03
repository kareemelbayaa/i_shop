import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  int get itemCount {
    return _orders.length;
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https(
        'ishop-20b25-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/orders.json');
    final timeStamp = DateTime.now();
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'amount':total,
            'dateTime':timeStamp.toIso8601String(),///bug
            'products':cartProducts.map((cartItem) =>
              {
                'id':cartItem.id,
                'title':cartItem.title,
                'quantity':cartItem.quantity,
                'price':cartItem.price,
              }
            ).toList(),
          },
        ),
      );

    _orders.insert(
      0,
      OrderItem(
        id: jsonDecode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();

    ///0 to insert it at the beginning of the list
  }
}
