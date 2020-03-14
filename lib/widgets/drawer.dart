import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/customRoute.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friends'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrderScreen.NamedRoute),
            // Navigator.of(context).pushReplacement(CustomRoute(
            //   builder: (ctx) => OrderScreen(),
            // )),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.create),
            title: Text("Your Products"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.NamedRoute),
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("LogOut"),
              onTap: () {
                Navigator.of(context).pop();
                Provider.of<Auth>(context, listen: false)
                    .logOut(); // Navigator.of(context)
                //     .pushReplacementNamed(UserProductScreen.NamedRoute),
              })
        ],
      ),
    );
  }
}
