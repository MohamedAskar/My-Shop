import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/progress_indicator.dart';
import '../widgets/product_manger_item.dart';
import '../screens/edit_product_screen.dart';

class ProductsManagerScreen extends StatelessWidget {
  static const routeName = '/ProductsManagerScreen';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.note_add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            color: Theme.of(context).accentColor,
          )
        ],
        title: Text(
          'Products Manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? PageProgressIndicator()
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, i) => ProductManagerItem(
                            id: productsData.items[i].id,
                            imageUrl: productsData.items[i].imageUrl,
                            price: productsData.items[i].price,
                            seller: productsData.items[i].seller,
                            title: productsData.items[i].title,
                            discount: productsData.items[i].discount,
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
      drawer: AppDrawer(),
    );
  }
}
