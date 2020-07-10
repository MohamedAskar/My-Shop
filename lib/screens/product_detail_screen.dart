import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import '../providers/cart.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';
import 'package:toast/toast.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/ProductsDetailScreen';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int dropdownValue = 1;
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findbyId(productId);
    final cart = Provider.of<Cart>(context, listen: false);
    var _islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    var hourDifference = 23 - DateTime.now().hour;
    var minsDifference = 59 - DateTime.now().minute;

    Widget productDetails = Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          loadedProduct.discount != 0
              ? Row(
                  children: <Widget>[
                    Text(
                      '\$${(loadedProduct.price * (1 - (loadedProduct.discount / 100))).toStringAsFixed(2)}  ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${loadedProduct.price}',
                      style: TextStyle(decoration: TextDecoration.lineThrough),
                    ),
                    Text(
                        '  Save \$${(loadedProduct.price - (loadedProduct.price * (1 - (loadedProduct.discount / 100)))).toStringAsFixed(2)} '),
                    Text('(${loadedProduct.discount}%)')
                  ],
                )
              : Text(
                  '\$${loadedProduct.price}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          Row(
            children: <Widget>[
              Text(
                'Quantity:  ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 6,
              ),
              DropdownButton<int>(
                elevation: 20,
                value: dropdownValue,
                onChanged: (int newValue) {
                  setState(() {
                    dropdownValue = newValue;

                    print(dropdownValue);
                  });
                },
                items: <int>[1, 2, 3, 4, 5, 6]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: new Text(value.toString()),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Text('Eligable for '),
              Text(
                'FREE Delivery ',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('& FREE Returns')
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(children: <Widget>[
            Text(
              'Order in the next  ',
            ),
            Text('$hourDifference hrs $minsDifference mins',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('  to receive it by ')
          ]),
          Text(
            '${DateFormat("EEE, MMM dd").format(DateTime.now().add(Duration(days: 2)))}',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'In Stock',
            style: TextStyle(
                color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Text('Ship from and Sold by '),
              Text(
                '${loadedProduct.seller}',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          InkWell(
              child: Container(
                padding: EdgeInsets.all(10),
                //margin: EdgeInsets.all(10),
                width: _islandscape
                    ? MediaQuery.of(context).size.height / 2
                    : double.infinity,
                decoration: BoxDecoration(color: Theme.of(context).accentColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Add To Cart',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.add_shopping_cart,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
              onTap: () {
                // showDialog(
                //     context: context,
                //     builder: (ctx) => AlertDialog(
                //           title: Text(
                //             'Item Added',
                //             style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //           content:
                //               Text('${loadedProduct.title} added to your cart'),
                //           actions: <Widget>[
                //             FlatButton(
                //               child: Text(
                //                 'Continue Shopping',
                //                 style: TextStyle(
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //               onPressed: () {
                //                 Navigator.of(context).pop(true);
                //                 Navigator.of(ctx).pushReplacementNamed('/');
                //               },
                //             ),
                //             FlatButton(
                //               child: Text(
                //                 'Procced to Checkout',
                //                 style: TextStyle(
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //               onPressed: () {
                //                 Navigator.of(context).pop(true);
                //                 Navigator.of(context)
                //                     .pushReplacementNamed(CartScreen.routeName);
                //               },
                //             )
                //           ],
                //         ));
                Toast.show(
                  'Item Added',
                  context,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.CENTER,
                  backgroundColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).accentColor,
                );
                cart.addItem(
                  loadedProduct.id,
                  (loadedProduct.price * (1 - (loadedProduct.discount / 100))),
                  loadedProduct.title,
                  loadedProduct.seller,
                  loadedProduct.imageUrl,
                  dropdownValue,
                );
              }),
        ],
      ),
    );
    Widget portriatMode = Column(
      children: <Widget>[
        Hero(
          tag: loadedProduct.id,
          child: PinchZoomImage(
            image: Image.network(
              loadedProduct.imageUrl,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            hideStatusBarWhileZooming: true,
            onZoomStart: () => print('start'),
            onZoomEnd: () => print('end'),
          ),
        ),
        productDetails,
      ],
    );
    Widget landscapeMode = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PinchZoomImage(
          image: Image.network(
            loadedProduct.imageUrl,
            //width: double.infinity,
            width: MediaQuery.of(context).size.width / 2,
            height: 400,
            fit: BoxFit.fill,
          ),
          hideStatusBarWhileZooming: true,
          zoomedBackgroundColor: Colors.transparent,
          onZoomStart: () => print('start'),
          onZoomEnd: () => print('end'),
        ),
        SizedBox(
          width: 30,
        ),
        productDetails
      ],
    );
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 250, 250, 1),
      appBar: AppBar(
        title: Text(
          loadedProduct.title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${loadedProduct.seller}',
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 16,
                    ),
                  ),
                  RatingBar(
                    onRatingChanged: (rating) => print(rating),
                    filledIcon: Icons.star,
                    emptyIcon: Icons.star_border,
                    halfFilledIcon: Icons.star_half,
                    isHalfAllowed: true,
                    initialRating: 4,
                    filledColor: Colors.amber,
                    emptyColor: Colors.amberAccent,
                    halfFilledColor: Colors.amberAccent,
                    size: 20,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 8),
              child: Text(
                '${loadedProduct.title}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            !_islandscape ? portriatMode : landscapeMode
          ],
        ),
      ),
    );
  }
}
