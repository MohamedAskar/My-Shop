import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shop/providers/auth.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

class CartItem extends StatefulWidget {
  final String id;
  final String productId;
  final String title;
  final String imageUrl;
  final double price;
  final String seller;
  final int quantity;
  final bool shrink;
  //final double discount;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.imageUrl,
    @required this.price,
    @required this.seller,
    @required this.quantity,
    @required this.shrink,
    //@required this.discount,
  });

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final products = Provider.of<Products>(context);
    final authData = Provider.of<Auth>(context, listen: false);
    final selectedProduct = products.findbyId(widget.id);
    bool _checkout = widget.shrink;
    var hourDifference = 23 - DateTime.now().hour;
    var minsDifference = 59 - DateTime.now().minute;
    return Dismissible(
      key: ValueKey(widget.id),
      background: Container(
        margin: EdgeInsets.all(10),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete_sweep,
          color: Colors.white,
          size: 60,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(
                    'Remove item',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content:
                      Text('Do you want to remove this Item from your Cart?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        'No',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    )
                  ],
                ));
      },
      onDismissed: (direction) {
        cart.removeItem(widget.productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 6,
        ),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${widget.seller}',
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('${widget.title}',
                            style: TextStyle(
                              fontSize: 18,
                            )),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          '\$ ${widget.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    _checkout
                        ? Text(
                            'x${widget.quantity}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        : SizedBox(),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        widget.imageUrl,
                      ),
                      radius: 50,
                    )
                  ],
                ),
                !_checkout
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
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
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text('Sold by '),
                              Text(
                                '${widget.seller}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Text('Quantity: '),
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: Colors.black,
                                  size: 14,
                                ),
                                onPressed: () {
                                  if (widget.quantity > 1) {
                                    cart.addItem(
                                      selectedProduct.id,
                                      (selectedProduct.price *
                                          (1 -
                                              (selectedProduct.discount /
                                                  100))),
                                      selectedProduct.title,
                                      selectedProduct.seller,
                                      selectedProduct.imageUrl,
                                      -1,
                                    );
                                  }
                                },
                              ),
                              Text(
                                '${widget.quantity}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add_circle,
                                  color: Colors.black,
                                  size: 14,
                                ),
                                onPressed: () {
                                  if (widget.quantity < 10) {
                                    cart.addItem(
                                      selectedProduct.id,
                                      (selectedProduct.price *
                                          (1 -
                                              (selectedProduct.discount /
                                                  100))),
                                      selectedProduct.title,
                                      selectedProduct.seller,
                                      selectedProduct.imageUrl,
                                      1,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(),
                              Row(
                                children: <Widget>[
                                  FlatButton(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                            selectedProduct.isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                Theme.of(context).accentColor),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        selectedProduct.isFavorite
                                            ? Text('Already Added')
                                            : Text('Add to wishlist'),
                                      ],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        selectedProduct
                                            .toggleFavorite(authData.token, authData.userId);
                                        //print(selectedProduct.isFavorite);
                                      });
                                    },
                                  ),
                                  FlatButton(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.delete_outline,
                                          color: Theme.of(context).errorColor,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          'Remove',
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).errorColor),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      cart.removeItem(widget.productId);
                                    },
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      )
                    : SizedBox(),
              ],
            )),
      ),
    );
  }
}
