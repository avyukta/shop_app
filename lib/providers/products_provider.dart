import 'dart:convert';

import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
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

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    String filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    print('userid: $userId');
    var url =
        'https://jan-ae413.firebaseio.com/Products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);

      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      url =
          'https://jan-ae413.firebaseio.com/UserFavouraite/$userId.json?auth=$authToken';
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);
      final List<Product> loadedProducts = [];
      extractData.forEach((prodId, prodData) {
        print(prodId);
        print(prodData);
        loadedProducts.add(Product(
            id: prodId.toString(),
            description: prodData['description'].toString(),
            imageUrl: prodData['imageurl'].toString(),
            price: prodData['price'],
            title: prodData['title'].toString(),
            isfavouraite: favData == null ? false : favData[prodId] ?? false));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
      // print(' error : $error');
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://jan-ae413.firebaseio.com/Products.json?auth=$authToken';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'creatorId': userId,
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageurl': product.imageUrl,
        }),
      );
      final newProduct = Product(
        title: product.title,
        imageUrl: product.imageUrl,
        description: product.description,
        price: product.price,
        id: json.decode(response.body)['name'],
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print('$error from products screen');
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newproduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      final url =
          'https://jan-ae413.firebaseio.com/Products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newproduct.title,
            'description': newproduct.description,
            'imageurl': newproduct.imageUrl,
            'price': newproduct.price
          }));
      _items[prodIndex] = newproduct;
      notifyListeners();
    } else {
      print('....');
    }
  }

  Future<void> removeProduct(String id) async {
    final url =
        'https://jan-ae413.firebaseio.com/Products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw Exception('could not delete the product');
    }
    existingProduct = null;
  }
}
