import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

import '../screens/product_detail_screen.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailScreen.routeName,
          arguments: product.id,
        );
      },
      child: Card(
        //elevation: 2,
        margin: EdgeInsets.all(4),
        child: Container(
          padding: EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(children: <Widget>[
                    Hero(
                      tag: product.id,
                      child: FadeInImage(
                        placeholder: AssetImage('assets/placeholder.png'),
                        image: NetworkImage(product.imageUrl),
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Consumer<Product>(
                        builder: (ctx, product, child) => IconButton(
                          //alignment: Alignment.topLeft,
                          icon: Icon(
                            !product.isFavorite
                                ? Icons.favorite_border
                                : Icons.favorite,
                            color: !product.isFavorite
                                ? Colors.grey
                                : Theme.of(context).accentColor,
                          ),
                          onPressed: () {
                            product.toggleFavorite(
                              authData.token,
                              authData.userId,
                            );
                          },
                        ),
                      ),
                    ),
                    if (product.discount != 0.0)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Chip(
                          label: Text(
                            '${product.discount}% off',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                      ),
                  ]),
                  Container(
                    height: 30,
                    padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: Text(
                      product.seller,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    child: Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  product.discount != 0
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '\$${(product.price * (1 - (product.discount / 100))).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              '\$${product.price}',
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough),
                            )
                          ],
                        )
                      : Text(
                          '\$${product.price}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                  RaisedButton(
                    color: Theme.of(context).accentColor,
                    textColor: Theme.of(context).primaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Add to cart'),
                        Icon(
                          Icons.add_shopping_cart,
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                    onPressed: () {
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Item Added!'),
                          duration: Duration(seconds: 1),
                          action: SnackBarAction(
                            label: 'UNDO',
                            textColor: Theme.of(context).primaryColor,
                            onPressed: () {
                              cart.removeSingleItem(product.id);
                            },
                          ),
                        ),
                      );
                      cart.addItem(
                        product.id,
                        (product.price * (1 - (product.discount / 100))),
                        product.title,
                        product.seller,
                        product.imageUrl,
                        1,
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
