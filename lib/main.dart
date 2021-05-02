import 'package:flutter/material.dart';
import 'package:i_shop/providers/cart.dart';
import 'package:i_shop/providers/order.dart';
import 'package:i_shop/screens/cart_screen.dart';
import 'package:i_shop/screens/edit_product_screen.dart';
import 'package:i_shop/screens/orders_screen.dart';
import 'package:i_shop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),

          ///now we can listen to the products anywhere in the application
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),

          ///now we can listen to the cart anywhere in the application
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),

          ///now we can listen to the cart anywhere in the application
        ),
      ],
      child: MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: ProductsOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen()
          }),
    );
  }
}
