import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cartProduct = Provider.of<Cart>(context, listen: false);
    return GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetail.NamedRoute, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                    color: Colors.red,
                    icon: product.isfavouraite
                        ? Icon(
                            Icons.favorite,
                          )
                        : Icon(
                            Icons.favorite_border,
                          ),
                    onPressed: () {
                      product.isFavouraitetoggle();
                    },
                  )),
          trailing: IconButton(
            color: Colors.red,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cartProduct.addItems(product.id, product.title, product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 2),
                content: Text("Item added to cart!"),
                action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cartProduct.removeOneItem(product.id);
                    }),
              ));
            },
          ),
          title: Text(
            product.title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ));
  }
}
