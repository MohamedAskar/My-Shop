import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/progress_indicator.dart';
import '../providers/products.dart';
import '../widgets/products_grid.dart';
import '../screens/auth_screen.dart';

class ShopFutureBuilder extends StatelessWidget {
  final bool fav;
  const ShopFutureBuilder({
    Key key,
    @required this.fav,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Provider.of<Products>(context, listen: false).fetchAndSetProducts(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return PageProgressIndicator();
        } else {
          if (dataSnapshot.error == null) {
            return Consumer<Products>(
              builder: (ctx, productData, child) => RefreshIndicator(
                onRefresh: () => productData.fetchAndSetProducts(),
                child: ProductsGrid(fav),
              ),
            );
          } else {
            return AlertDialog(
              title: Text('An error occurred'),
              content: Text(
                  'Something went wrong, Check out your internet connenction or try again later'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    //exit(0);
                    Navigator.of(context)
                        .pushReplacementNamed(AuthScreen.routeName);
                  },
                )
              ],
            );
          }
        }
      },
    );
  }
}
