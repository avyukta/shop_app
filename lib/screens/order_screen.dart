import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const NamedRoute = '/order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // var _isLoading = false;
  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) async {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await Provider.of<Orders>(context, listen: false).fetchSetOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Orders"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchSetOrders(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Consumer<Orders>(
                      builder: (ctx, orderData, child) => ListView.builder(
                            itemCount: orderData.orders.length,
                            itemBuilder: (ctx, index) =>
                                OrderItem(orders: orderData.orders[index]),
                          ));
                }
              }
            }));
  }
}
