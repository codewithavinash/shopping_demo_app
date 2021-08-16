import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'package:provider/provider.dart';

import '../provider/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) async {
    _isLoading = true;
    // Provider.of<Orders>(context, listen: false)
    //     .fetchAndSetOrders()
    //     .then((_) {

    //     });
    // setState(() {
    //   _isLoading = false;
    //   // });
    // });
    // super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Your Order Rebuilds');
    // final orderData = Provider.of<Orders>(context); // this will result in loop
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                //error case
                if (dataSnapshot.error != null) {
                  //error handling
                  return Center(child: Text('Error'));
                } else {
                  //success case
                  return Consumer<Orders>(
                    builder: (ctx, orderData, child) => ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                    ),
                  );
                }
              }
            })
        // _isLoading
        //     ? Center(
        //         child: CircularProgressIndicator(),
        //       )
        //     : ListView.builder(
        //         itemCount: orderData.orders.length,
        //         itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
        //       ),
        );
  }
}
