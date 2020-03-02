import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/drawer.dart';

import '../widgets/gridview_builder.dart';

enum FilterItems { Favouraite, All }

class OverViewScreen extends StatefulWidget {
  @override
  _OverViewScreenState createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {
  var _showFavouraiteFilter = false;

  var _init = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_init) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProduct()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productFilterContent = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.cartLength.toString(),
              color: Colors.red,
            ),
            child: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.NamedRoute);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterItems filter) {
              setState(() {
                if (filter == FilterItems.Favouraite) {
                  // productFilterContent.showFavouraiteOnly();
                  _showFavouraiteFilter = true;
                } else {
                  // productFilterContent.showAll();
                  _showFavouraiteFilter = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favouraite'),
                value: FilterItems.Favouraite,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterItems.All,
              )
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<Products>(context, listen: false).fetchAndSetProduct(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GridviewBuild(_showFavouraiteFilter),
        ),
      ),
    );
  }
}
