import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//widgets
import 'screens/cart_screen.dart';

//screens
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';

//provider
import '../provider/products.dart';
import '../provider/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //provided
        ChangeNotifierProvider(
          // value: Products(), // Do not use ChangeNotifierProvider.value when you are instantiating a class
          create: (ctx) => Products(), // provided class
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
      ],
      child: MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: ProductsOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
          }),
    );
  }
}
