import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:i_shop/providers/cart.dart';
import 'package:i_shop/providers/order.dart';
import 'package:i_shop/widgets/cart_item.dart' as cartItem;
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalAmount}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        ///place order
                        Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(),
                          cart.totalAmount,
                        );
                        cart.clearCart();
                      },
                      child: Text('Place Order'))
                ],
              ),
              padding: EdgeInsets.all(8),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (context, index) {
                  return cartItem.CartItem(
                    id: cart.items.values.toList()[index].id,
                    productId: cart.items.keys.toList()[index],
                    title: cart.items.values.toList()[index].title,
                    price: cart.items.values.toList()[index].price,
                    quantity: cart.items.values.toList()[index].quantity,
                  );
                }),
          )
        ],
      ),
    );
  }
}
