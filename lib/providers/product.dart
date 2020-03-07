import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  bool isfavouraite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.imageUrl,
      @required this.description,
      @required this.price,
      this.isfavouraite = false});
  void _setFavValue(bool newValue) {
    isfavouraite = newValue;
    notifyListeners();
  }

  Future<void> isFavouraitetoggle(String token, String userId) async {
    final oldFavouraite = isfavouraite;
    isfavouraite = !isfavouraite;
    notifyListeners();

    try {
      final url =
          'https://jan-ae413.firebaseio.com/UserFavouraite/$userId/$id.json?auth=$token';
      final response = await http.put(url,
          body: json.encode(
            isfavouraite,
          ));
      if (response.statusCode >= 400) {
        _setFavValue(oldFavouraite);
      }
    } catch (error) {
      _setFavValue(oldFavouraite);
    }
  }
}
