import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:i_shop/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  const CartItem(
      {Key key, this.id, this.title, this.price, this.quantity, this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 40,
        ),
      ),
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (builderContext) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('do you want to remove the item from the cart?'),
            actions: [
              ElevatedButton(onPressed: () {
                Navigator.of(builderContext).pop(false);
              }, child: Text('No')),
              ElevatedButton(onPressed: () {
                Navigator.of(builderContext).pop(true);
              }, child: Text('Yes'))
            ],
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(child: Text('\$$price'))),
            ),
            title: Text('$title'),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('× $quantity'),
          ),
        ),
      ),
    );
  }
}
