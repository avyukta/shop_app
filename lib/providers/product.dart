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

  Future<void> isFavouraitetoggle() async {
    final oldFavouraite = isfavouraite;
    isfavouraite = !isfavouraite;
    notifyListeners();

    try {
      final url = 'https://jan-ae413.firebaseio.com/Products/$id.json';
      final response = await http.patch(url,
          body: json.encode({
            'isFavouraite': isfavouraite,
          }));
      if (response.statusCode >= 400) {
        _setFavValue(oldFavouraite);
      }
    } catch (error) {
      _setFavValue(oldFavouraite);
    }
  }
}
