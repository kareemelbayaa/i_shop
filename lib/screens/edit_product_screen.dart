import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_shop/providers/product.dart';
import 'package:i_shop/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  ///very important to be able to submit the form
  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceFocusNode.dispose();

    ///focus nodes should be disposed to avoid memory leaks
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();

    ///
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _initValues['title'],
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_priceFocusNode),
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: value,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        isFavorite: _editedProduct.isFavorite,
                        imageUrl: _editedProduct.imageUrl);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'value cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                    initialValue: _initValues['price'],
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) => FocusScope.of(context)
                        .requestFocus(_descriptionFocusNode),
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value),
                          isFavorite: _editedProduct.isFavorite,
                          imageUrl: _editedProduct.imageUrl);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'value cannot be empty';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next),
                TextFormField(
                    initialValue: _initValues['description'],
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'value cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value,
                          price: _editedProduct.price,
                          isFavorite: _editedProduct.isFavorite,
                          imageUrl: _editedProduct.imageUrl);
                    },
                    textInputAction: TextInputAction.next),
                Expanded(
                    child: TextFormField(
                      /// you can't have an initalValue and a controller
                  // initialValue: _initValues['imageUrl'],
                  decoration: InputDecoration(labelText: 'Image URL'),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  controller: _imageUrlController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'value cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        isFavorite: _editedProduct.isFavorite,
                        imageUrl: value);
                  },
                  onFieldSubmitted: (_) {
                    _saveForm();
                  },
                  onEditingComplete: () {
                    setState(() {});
                  },
                )),
              ],
            ),
          ),
        ));
  }

  void _saveForm() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    ///check if the product exist first
    if(_editedProduct.id!=null){
      Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id,_editedProduct);

    }else{
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }
}
