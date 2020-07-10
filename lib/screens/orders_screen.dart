import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shop/widgets/app_drawer.dart';
import '../widgets/cart_item.dart' as ci;
import '../providers/cart.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/OrderScreen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    final landScapeMode =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final Widget itemsList = Expanded(
      child: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (ctx, i) => ci.CartItem(
          id: cart.items.values.toList()[i].id,
          productId: cart.items.keys.toList()[i],
          imageUrl: cart.items.values.toList()[i].imageUrl,
          price: cart.items.values.toList()[i].price,
          title: cart.items.values.toList()[i].title,
          quantity: cart.items.values.toList()[i].quantity,
          seller: cart.items.values.toList()[i].seller,
          shrink: true,
        ),
      ),
    );

    final Widget orderDetails = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Icon(Icons.payment)
            ],
          ),
        ),
        Container(
          width: landScapeMode
              ? MediaQuery.of(context).size.width / 2
              : double.infinity,
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Pay with Cash',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.attach_money,
                      color: Colors.green,
                    ))
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: landScapeMode
              ? MediaQuery.of(context).size.width / 2
              : double.infinity,
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          cart.totalQuantity > 1
                              ? Text('Subtotal (${cart.totalQuantity} items)')
                              : Text('Subtotal (${cart.totalQuantity} item)'),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Shipping Fees'),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Estimated VAT (%14)'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '\$${cart.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          cart.totalAmount < 50
                              ? Text(
                                  cart.items.length == 0 ? '\$0.00' : '\$5.00',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  'Free',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '\$${(cart.totalAmount * 0.14).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'TOTAL',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            cart.totalAmount > 50
                                ? '\$${(cart.totalAmount + cart.totalAmount * 0.14).toStringAsFixed(2)}'
                                : cart.items.length == 0
                                    ? '\$0.00'
                                    : '\$${(cart.totalAmount + cart.totalAmount * 0.14 + 5).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Place Order',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: !landScapeMode
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                orderDetails,
                itemsList,
                PlaceOrderButton(landScapeMode: landScapeMode, cart: cart),
              ],
            )
          : Row(
              children: <Widget>[
                itemsList,
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    orderDetails,
                    PlaceOrderButton(landScapeMode: landScapeMode, cart: cart)
                  ],
                ),
                PlaceOrderButton(landScapeMode: landScapeMode, cart: cart)
              ],
            ),
      drawer: AppDrawer(),
    );
  }
}

class PlaceOrderButton extends StatefulWidget {
  const PlaceOrderButton({
    Key key,
    @required this.landScapeMode,
    @required this.cart,
  }) : super(key: key);

  final bool landScapeMode;
  final Cart cart;

  @override
  _PlaceOrderButtonState createState() => _PlaceOrderButtonState();
}

class _PlaceOrderButtonState extends State<PlaceOrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(6),
        width: widget.landScapeMode
            ? MediaQuery.of(context).size.width / 2 - 4
            : double.infinity,
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              )
            : Text(
                'PLACE ORDER',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
      ),
      onTap: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  context: context,
                  builder: (_) {
                    return GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Text(
                                'Order Confirmation',
                                style: TextStyle(
                                  fontFamily: 'Lexend',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Center(
                                child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 200,
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Congratulations!',
                              style: TextStyle(
                                fontFamily: 'Lexend',
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              'Your Order placed Successfully.',
                              style: TextStyle(
                                fontFamily: 'Lexend',
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Order will be delivered by ',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  '${DateFormat("EEE, MMM dd").format(DateTime.now().add(Duration(days: 2)))}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).popAndPushNamed('/');
                                  },
                                  child: Text(
                                    'Continue Shopping',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
    );
  }
}
