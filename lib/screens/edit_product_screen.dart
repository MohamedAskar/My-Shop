import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

import 'package:provider/provider.dart';
import '../widgets/progress_indicator.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/ProductManagerItem';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {


  final _priceFocusNode = FocusNode();
  final _sellerFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _discountFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    imageUrl: '',
    seller: '',
    isFavorite: false,
    discount: 0,
  );
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findbyId(productId);

        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if ((!_imageUrlController.text.startsWith('http') &&
            !_imageUrlController.text.startsWith('https')) ||
        (!_imageUrlController.text.endsWith('.png') &&
            !_imageUrlController.text.endsWith('.jpg') &&
            !_imageUrlController.text
                .endsWith('.jpeg'))) if (!_imageUrlFocusNode.hasFocus) {
      return;
    }
    setState(() {});
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occurred'),
                  content: Text('Something went wrong'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      }

      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Product',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              textColor: Theme.of(context).accentColor,
              onPressed: () {
                _saveForm();
                Navigator.of(context).pop(true);
              },
            )
          ],
        ),
        body: _isLoading
            ? PageProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 0,
                          ),
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).accentColor,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Center(
                                child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),),
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: _editedProduct.title,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          icon: Icon(
                            Icons.title,
                            size: 30,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        cursorColor: Theme.of(context).accentColor,
                        textCapitalization: TextCapitalization.sentences,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (val) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite,
                              price: _editedProduct.price,
                              seller: _editedProduct.seller,
                              title: val,
                              discount: _editedProduct.discount);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter a Title.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _editedProduct.price.toString(),
                        decoration: InputDecoration(
                          labelText: 'Price',
                          icon: Icon(
                            Icons.attach_money,
                            size: 30,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        cursorColor: Theme.of(context).accentColor,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_sellerFocusNode);
                        },
                        onSaved: (val) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite,
                              price: double.parse(val),
                              seller: _editedProduct.seller,
                              title: _editedProduct.title,
                              discount: _editedProduct.discount);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter the Price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please Enter a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please Enter a number greater than 0.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _editedProduct.seller,
                        decoration: InputDecoration(
                          labelText: 'Seller',
                          icon: Icon(
                            Icons.person_outline,
                            size: 30,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor: Theme.of(context).accentColor,
                        focusNode: _sellerFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_imageUrlFocusNode);
                        },
                        onSaved: (val) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite,
                              price: _editedProduct.price,
                              seller: val,
                              title: _editedProduct.title,
                              discount: _editedProduct.discount);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter the Seller';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Image Url',
                          icon: Icon(
                            Icons.attach_file,
                            size: 30,
                          ),
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.next,
                        cursorColor: Theme.of(context).accentColor,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_discountFocusNode);
                        },
                        onSaved: (val) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              imageUrl: val,
                              isFavorite: _editedProduct.isFavorite,
                              price: _editedProduct.price,
                              seller: _editedProduct.seller,
                              title: _editedProduct.title,
                              discount: _editedProduct.discount);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter an Image Url';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please Enter a VALID Url';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg')) {
                            return 'Please Enter a Valid Image Url';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                          initialValue: _editedProduct.discount.toString(),
                          decoration: InputDecoration(
                              labelText: 'Discount',
                              icon: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  '%',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              )),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          cursorColor: Theme.of(context).accentColor,
                          focusNode: _discountFocusNode,
                          onSaved: (val) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite,
                              price: _editedProduct.price,
                              seller: _editedProduct.seller,
                              title: _editedProduct.title,
                              discount: double.parse(val),
                            );
                          })
                    ],
                  ),
                ),
              ));
  }
}
