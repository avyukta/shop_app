import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/productItem.dart';
import '../providers/products_provider.dart';

class GridviewBuild extends StatelessWidget {
  final bool favItem;
  GridviewBuild(this.favItem);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final product = favItem ? productData.favItems : productData.items;
    return GridView.builder(
        itemCount: product.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
            value: product[index],
            child: ProductItem(
                // id: product[index].id,
                // title: product[index].title,
                // imgurl: product[index].imageUrl,
                )));
  }
}
