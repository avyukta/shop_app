import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

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
  final String authToken;
  Orders(this.authToken, this._orders);
  List<OrderItems> _orders = [];

  List<OrderItems> get orders {
    return [..._orders];
  }

  Future<void> fetchSetOrders() async {
    final url = 'https://jan-ae413.firebaseio.com/Orders.json?auth=$authToken';
    final response = await http.get(url);
    print(json.decode(response.body));
    final extractData = json.decode(response.body) as Map<String, dynamic>;
    if (extractData.isEmpty) {
      return;
    }
    List<OrderItems> loadedProducts = [];
    extractData.forEach((ordId, ordData) {
      loadedProducts.add(OrderItems(
        id: ordId,
        amount: ordData['amount'],
        dateTime: DateTime.parse(ordData['dateTime']),
        products: (ordData['products'] as List<dynamic>)
            .map((ci) => CartItems(
                id: ci['id'],
                price: ci['price'],
                quantity: ci['quantity'],
                title: ci['title']))
            .toList(),
      ));
    });
    _orders = loadedProducts;
    notifyListeners();
  }

  Future<void> addOrders(List<CartItems> cartProducts, double total) async {
    var timeStamp = DateTime.now();
    final url = 'https://jan-ae413.firebaseio.com/Orders.json?auth=$authToken';
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItems(
          id: json.decode(response.body)['name'],
          // title: title,
          products: cartProducts,
          amount: total,
          dateTime: timeStamp,
        ));
    notifyListeners();
  }
}
