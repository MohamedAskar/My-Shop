import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:toast/toast.dart';
import '../screens/edit_product_screen.dart';

class ProductManagerItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final String seller;
  final double discount;
  ProductManagerItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.price,
    @required this.seller,
    @required this.discount,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
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
                  '$seller',
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
                        Text('$title',
                            style: TextStyle(
                              fontSize: 18,
                            )),
                        SizedBox(
                          height: 6,
                        ),
                        discount == 0
                            ? Text(
                                '\$ $price',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              )
                            : Text(
                                '\$ ${((price) * (1 - (discount / 100))).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                        SizedBox(
                          height: 6,
                        ),
                        discount != 0
                            ? Text('Discount: ${discount.toStringAsFixed(0)}%')
                            : SizedBox()
                      ],
                    ),
                    // Image.network(
                    //   imageUrl,
                    //   fit: BoxFit.scaleDown,
                    //   height: 100,
                    //   width: 80,
                    // )
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        imageUrl,
                      ),
                      radius: 40,
                    )
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
                              Icon(Icons.edit,
                                  color: Theme.of(context).accentColor),
                              SizedBox(
                                width: 6,
                              ),
                              Text('Edit Product'),
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                EditProductScreen.routeName,
                                arguments: id);
                          },
                        ),
                        FlatButton(
                          textColor: Theme.of(context).errorColor,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.delete_outline,
                                color: Theme.of(context).errorColor,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text('Remove'),
                            ],
                          ),
                          onPressed: () async {
                            try {
                              await Provider.of<Products>(context,
                                      listen: false)
                                  .deleteProduct(id);
                            } catch (error) {
                              Toast.show('Deleting Failed', context);
                            }
                          },
                        ),
                      ],
                    )
                  ],
                )
              ],
            )));
  }
}
