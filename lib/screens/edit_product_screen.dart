import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const NamedRoute = '/edit-product-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _printFocusNode = FocusNode();
  final _desFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  var _editedProduct = Product(
      id: null,
      title: '',
      description: '',
      imageUrl: '',
      price: 0,
      isfavouraite: false);

  final _form = GlobalKey<FormState>();
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty) {
        setState(() {});
      }
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.contains('.png') &&
              !_imageUrlController.text.contains('.jpg') &&
              !_imageUrlController.text.contains('.jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _printFocusNode.dispose();
    _desFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    print(_editedProduct.id);
    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
    print(_editedProduct.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_printFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter some value";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: null,
                          title: value,
                          imageUrl: _editedProduct.imageUrl,
                          description: _editedProduct.description,
                          price: _editedProduct.price);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _printFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_desFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter some value";
                      }
                      if (double.parse(value) <= 0) {
                        return 'plese enter some valid value';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: null,
                          title: _editedProduct.title,
                          imageUrl: _editedProduct.imageUrl,
                          description: _editedProduct.description,
                          price: double.parse(value));
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                    focusNode: _desFocusNode,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter some value";
                      }
                      if (value.length < 10) {
                        return 'please enter more than 10 characters';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: null,
                          title: _editedProduct.title,
                          imageUrl: _editedProduct.imageUrl,
                          description: value,
                          price: _editedProduct.price);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1,
                                style: BorderStyle.solid)),
                        child: _imageUrlController.text.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Enter Image Url.",
                                    softWrap: true,
                                  ),
                                ),
                              )
                            : FittedBox(
                                child: Image.network(
                                  _imageUrlController.text,
                                  // '${_imageUrlController.text}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Image Url'),
                          keyboardType: TextInputType.url,
                          controller: _imageUrlController,
                          textInputAction: TextInputAction.done,
                          focusNode: _imageUrlFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some value";
                            }
                            if (!value.startsWith('http') &&
                                !value.startsWith('https')) {
                              return 'please enter valid image url';
                            }
                            if (!value.contains('.png') &&
                                !value.contains('.jpg') &&
                                !value.contains('.jpeg')) {
                              return 'please enter valid image url';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: null,
                                title: _editedProduct.title,
                                imageUrl: value,
                                description: _editedProduct.description,
                                price: _editedProduct.price);
                          },
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
