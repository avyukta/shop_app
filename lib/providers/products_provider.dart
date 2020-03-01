import 'dart:convert';

import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // var _showFavouraite = false;

  List<Product> get items {
    // if (_showFavouraite) {
    //   return _items.where((prodItem) => prodItem.isfavouraite).toList();
    // }
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((prodItem) => prodItem.isfavouraite).toList();
  }
  // void showFavouraiteOnly() {
  //   _showFavouraite = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavouraite = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) {
    const url = 'https://jan-ae413.firebaseio.com/Products';
    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageurl': product.imageUrl,
        'isFavouraite': product.isfavouraite
      }),
    )
        .then((response) {
      final newProduct = Product(
        title: product.title,
        imageUrl: product.imageUrl,
        description: product.description,
        price: product.price,
        id: json.decode(response.body)['name'],
      );
      _items.insert(0, newProduct);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  void updateProduct(String id, Product newproduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newproduct;
      notifyListeners();
    } else {
      print('....');
    }
  }

  void removeProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
