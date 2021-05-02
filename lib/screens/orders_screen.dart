import 'package:flutter/material.dart';
import 'package:i_shop/providers/order.dart';
import 'package:i_shop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:i_shop/widgets/order_item.dart' as orderItemWidget;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
          itemCount: orders.orders.length,
          itemBuilder: (context, index) {
              return orderItemWidget.OrderItem(orderItem: orders.orders[index],);
          }),
    );
  }
}
