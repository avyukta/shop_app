import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const NamedRoute = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Total",
                  style: Theme.of(context).textTheme.title,
                ),
                Spacer(),
                Chip(
                  backgroundColor: Theme.of(context).primaryColor,
                  label: Text(
                    "\$  ${cart.totalPrice.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                OrderButton(cart: cart)
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, index) => ci.CartItem(
                        id: cart.items.values.toList()[index].id,
                        productId: cart.items.keys.toList()[index],
                        title: cart.items.values.toList()[index].title,
                        price: cart.items.values.toList()[index].price,
                        quantity: cart.items.values.toList()[index].quantity,
                      )))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: (widget.cart.totalPrice <= 0 || _isLoading)
            ? () => null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                Navigator.of(context).pushNamed(OrderScreen.NamedRoute);
                await Provider.of<Orders>(context, listen: false).addOrders(
                    widget.cart.items.values.toList(), widget.cart.totalPrice);
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
              },
        child: _isLoading
            ? CircularProgressIndicator()
            : Text(
                "ORDER NOW",
                style: Theme.of(context).textTheme.button,
              ));
  }
}
