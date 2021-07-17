import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.FavouriteIems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[
            i], //.value should be used in reusable object like grid/list

        // create: (c) => //builder doesn't support latest versoin of flutter
        //     products[i],

        child: ProductItem(
            // products[i].id,        // we are providing single product item
            // products[i].title,    // so we don't need to
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
