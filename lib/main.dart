import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';
import './screens/overview_screen.dart';
import './screens/product_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => null,
            update: (ctx, auth, previousProducts) => Products(auth.token,
                previousProducts == null ? [] : previousProducts.items),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProvider.value(
            value: Orders(),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop App',
            home: authData.isAuth ? OverViewScreen() : AuthScreen(),
            theme: ThemeData(
                primaryColor: Colors.blue,
                errorColor: Colors.red,
                textTheme: TextTheme(
                    title: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    subtitle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    subhead: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    button: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold))),
            routes: {
              AuthScreen.NamedRoute: (ctx) => AuthScreen(),
              OverViewScreen.NamedRoute: (ctx) => OverViewScreen(),
              ProductDetail.NamedRoute: (ctx) => ProductDetail(),
              CartScreen.NamedRoute: (ctx) => CartScreen(),
              OrderScreen.NamedRoute: (ctx) => OrderScreen(),
              UserProductScreen.NamedRoute: (ctx) => UserProductScreen(),
              EditProductScreen.NamedRoute: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
