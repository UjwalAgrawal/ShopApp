import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _editedProduct = Product(
    id: null,
    imageUrl: '',
    title: '',
    description: '',
    price: 0,
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      if (_editedProduct.id != null) {
        Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } else {
        Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      }
      Navigator.pop(context);
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Prodcut"),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _initValues['title'],
                  decoration: InputDecoration(
                    labelText: "Title",
                  ),
                  validator: (value) {
                    if (value.isEmpty) return "Please provide a value";
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  onSaved: (newValue) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      imageUrl: _editedProduct.imageUrl,
                      title: newValue,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initValues['price'],
                  decoration: InputDecoration(
                    labelText: "Price",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please provide a price";
                    }
                    if (double.tryParse(value) == null ||
                        double.tryParse(value) <= 0) {
                      return "Please provide a valid price.";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onSaved: (newValue) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      imageUrl: _editedProduct.imageUrl,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(newValue),
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initValues['description'],
                  decoration: InputDecoration(
                    labelText: "Description",
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter a description.";
                    }
                    if (value.length < 6) {
                      return "Should be at least 6 characters.";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      imageUrl: _editedProduct.imageUrl,
                      title: _editedProduct.title,
                      description: newValue,
                      price: _editedProduct.price,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text(
                              'Enter a URL',
                              textAlign: TextAlign.center,
                            )
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter a URL";
                          }
                          if (!value.startsWith("http") &&
                              !value.startsWith("https")) {
                            return "Please enter a valid URL (http/https)";
                          }
                          if (!value.endsWith(".png") &&
                              !value.endsWith(".jpg") &&
                              !value.endsWith(".jpeg")) {
                            return "Please enter a valid image URL";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            imageUrl: newValue,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    child: Text("Submit"),
                    onLongPress: () => SnackBar(
                      content: const Text("Submit the product"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
