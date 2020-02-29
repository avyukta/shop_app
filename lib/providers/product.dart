import 'package:flutter/foundation.dart';

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

  void isFavouraitetoggle() {
    isfavouraite = !isfavouraite;
    notifyListeners();
  }
}