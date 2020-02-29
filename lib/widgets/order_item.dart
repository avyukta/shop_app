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

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              '\$  ${widget.orders.amount}',
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
          if (_expanded)
            Container(
              height: min(widget.orders.products.length * 60.0, 100),
              child: ListView(
                  children: widget.orders.products
                      .map((orderProduct) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(orderProduct.title),
                                Text(
                                    '${orderProduct.quantity}x  \$ ${orderProduct.price}'),
                              ],
                            ),
                          ))
                      .toList()),
            ),
        ],
      ),
    );
  }
}
