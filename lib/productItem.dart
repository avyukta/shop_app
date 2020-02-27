import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgurl;

  ProductItem({this.id, this.title, this.imgurl});
  @override
  Widget build(BuildContext context) {
    return GridTile(
        child: Image.network(
          imgurl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
            color: Colors.red,
            icon: Icon(Icons.favorite),
            onPressed: () {},
          ),
          trailing: IconButton(
            color: Colors.red,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ));
  }
}
