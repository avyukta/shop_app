import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/cart.dart';

class OrderItems {
  final String id;
  // final String title;
  final DateTime dateTime;
  final List<CartItems> products;
  final double amount;

  OrderItems({
    @required this.id,
    // @required this.title,
    @required this.dateTime,
    @required this.products,
    @required this.amount,
  });
}

class Orders with ChangeNotifier {
  List<OrderItems> _orders = [];

  List<OrderItems> get orders {
    return [..._orders];
  }

  void addOrders(List<CartItems> products, double total) {
    _orders.insert(
        0,
        OrderItems(
          id: DateTime.now().toString(),
          // title: title,
          products: products,
          amount: total,
          dateTime: DateTime.now(),
        ));
    notifyListeners();
  }
}
