import 'package:flutter/material.dart';
import 'package:multi_store_app/provider/cartprovider.dart';
import 'package:multi_store_app/provider/wishlistprovider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class WishListItems extends StatelessWidget {
  const WishListItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WishList>(
      builder: (context, wish, child) {
        return ListView.builder(
            itemCount: wish.count,
            itemBuilder: (context, index) {
              final product = wish.getWishItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Card(
                  color: Colors.blueGrey[100]!.withOpacity(0.8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //color: Colors.blueGrey[100]
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            //color: Colors.blueGrey[100]
                          ),
                          height: 100,
                          width: 120,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                wish.getWishItems[index].imagesUrl[0],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  wish.getWishItems[index].name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.blueGrey[900],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontFamily: 'Acme',
                                      letterSpacing: 1),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      (' ₹  ') +
                                          wish.getWishItems[index].price
                                              .toString(),
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          fontFamily: 'Acme',
                                          letterSpacing: 1),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              context
                                                  .read<WishList>()
                                                  .removeItem(product);
                                            },
                                            icon: Icon(
                                              Icons.delete_outlined,
                                              color: Colors.blueGrey[900],
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        context
                                                        .watch<Cart>()
                                                        .getItems
                                                        .firstWhereOrNull(
                                                            (element) =>
                                                                element
                                                                    .documentId ==
                                                                product
                                                                    .documentId) !=
                                                    null ||
                                                product.qty == 0
                                            ? SizedBox()
                                            : IconButton(
                                                onPressed: () {
                                                  context.read<Cart>().addItem(
                                                      product.name,
                                                      product.price,
                                                      1,
                                                      product.quantity,
                                                      product.imagesUrl,
                                                      product.documentId,
                                                      product.suppId);
                                                },
                                                icon: Icon(
                                                    Icons
                                                        .add_shopping_cart_outlined,
                                                    color:
                                                        Colors.blueGrey[900]),
                                              ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
