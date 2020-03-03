import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgurl;

  UserProductItem(this.id, this.title, this.imgurl);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.title,
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgurl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.NamedRoute, arguments: id);
                }),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .removeProduct(id);
                  } catch (error) {
                    scaffold.showSnackBar(SnackBar(
                      content: Text(
                        'Deletion failed',
                        textAlign: TextAlign.center,
                      ),
                    ));
                  }
                }),
          ],
        ),
      ),
    );
  }
}
