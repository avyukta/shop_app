import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders.dart';

class OrderItem extends StatefulWidget {
  final OrderItems orders;
  OrderItem({this.orders});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem>
    with SingleTickerProviderStateMixin {
  var _expanded = false;

  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded
          ? min(widget.orders.products.length * 40.0 + 100, 200)
          : 100,
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                '\$  ${widget.orders.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.title,
              ),
              subtitle: Text(DateFormat('yyy MM dd hh:mm')
                  .format(widget.orders.dateTime)
                  .toString()),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _expanded
                  ? min(widget.orders.products.length * 60.0, 100)
                  : 0,
              child: ListView(
                  children: widget.orders.products
                      .map((orderProduct) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  orderProduct.title,
                                  style: Theme.of(context).textTheme.title,
                                ),
                                Text(
                                    '${orderProduct.quantity}x  \$ ${orderProduct.price.toStringAsFixed(2)}'),
                              ],
                            ),
                          ))
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
