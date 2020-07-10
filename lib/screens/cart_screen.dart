import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart' as ci;
import '../screens/orders_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/CartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final Widget cartItems = Expanded(
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
          shrink: false,
        ),
      ),
    );

    final Widget checkoutDetails = Container(
      //height: 200,
      width:
          isLandscape ? MediaQuery.of(context).size.width / 2 : double.infinity,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              cart.totalQuantity > 1
                  ? Text('Cart total (${cart.totalQuantity} items)')
                  : Text('Cart total (${cart.totalQuantity} item)'),

              SizedBox(height: 10,),
              isLandscape
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: cart.itemCount,
                        itemBuilder: (ctx, i) => Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('${cart.items.values.toList()[i].quantity}x  ${cart.items.values.toList()[i].title}'),
                            Text('\$${cart.items.values.toList()[i].price}/item')
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'TOTAL',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).primaryTextTheme.title,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              InkWell(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    //margin: EdgeInsets.all(10),
                    width: isLandscape
                        ? MediaQuery.of(context).size.width / 2 - 4
                        : double.infinity,
                    decoration:
                        BoxDecoration(color: Theme.of(context).accentColor),
                    child: Text(
                      'CHECKOUT NOW',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  onTap: () {
                    if (cart.items.length > 0) {
                      
                      //cart.clear();
                      Navigator.of(context).pushNamed(OrdersScreen.routeName);
                    } else {
                      return;
                    }
                  })
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
      ),
      body: cart.items.length == 0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Your Shopping Cart is empty!',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                    child: Image.asset(
                  'assets/empty.png',
                  fit: BoxFit.scaleDown,
                  height: 300,
                  width: 300,
                  alignment: Alignment.center,
                ))
              ],
            )
          : !isLandscape
              ? Column(
                  children: <Widget>[cartItems, checkoutDetails],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[cartItems, checkoutDetails],
                ),
      drawer: AppDrawer(),
    );
  }
}
