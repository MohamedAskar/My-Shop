import 'package:flutter/material.dart';
import 'package:shop/widgets/app_drawer.dart';
import '../widgets/shop_future_builder.dart';


class WishListScreen extends StatelessWidget {
  static const routeName = '/WishlistScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wishlist',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
      ),
      body: new ShopFutureBuilder(fav: true,),
      drawer: AppDrawer(),
    );
  }
}


