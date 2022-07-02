import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/provider/cartprovider.dart';
import 'package:multi_store_app/provider/wishlistprovider.dart';
import 'package:provider/provider.dart';

class CartItems extends StatelessWidget {
  const CartItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return ListView.builder(
            itemCount: cart.count,
            itemBuilder: (context, index) {
              final product = cart.getItems[index];
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
                                cart.getItems[index].imagesUrl[0],
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
                                  cart.getItems[index].name,
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
                                          cart.getItems[index].price.toString(),
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          fontFamily: 'Acme',
                                          letterSpacing: 1),
                                    ),
                                    Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                          color: Colors.blueGrey[900],
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Row(
                                        children: [
                                          product.qty == 1
                                              ? IconButton(
                                                  onPressed: () {
                                                    showCupertinoModalPopup<
                                                            void>(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            CupertinoActionSheet(
                                                              title: const Text(
                                                                  'Remove Item'),
                                                              message: const Text(
                                                                  'Sure Want to Delete the Item ?'),
                                                              actions: <
                                                                  CupertinoActionSheetAction>[
                                                                CupertinoActionSheetAction(
                                                                  onPressed:
                                                                      () async {
                                                                    context.read<WishList>().getWishItems.firstWhereOrNull((item) => item.documentId == product.documentId) !=
                                                                            null
                                                                        ? context
                                                                            .read<
                                                                                Cart>()
                                                                            .removeItem(
                                                                                product)
                                                                        : await context.read<WishList>().addWishlistItem(
                                                                            product.name,
                                                                            product.price,
                                                                            1,
                                                                            product.quantity,
                                                                            product.imagesUrl,
                                                                            product.documentId,
                                                                            product.suppId);
                                                                    context
                                                                        .read<
                                                                            Cart>()
                                                                        .removeItem(
                                                                            product);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      'Move To WishList'),
                                                                ),
                                                                CupertinoActionSheetAction(
                                                                  onPressed:
                                                                      () {
                                                                    context
                                                                        .read<
                                                                            Cart>()
                                                                        .removeItem(
                                                                            product);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      'Delete Item'),
                                                                ),
                                                              ],
                                                              cancelButton:
                                                                  TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ),
                                                            ));
                                                  },
                                                  icon: Icon(
                                                    Icons.delete_outline,
                                                    size: 16,
                                                    color: Colors.blueGrey[100]!
                                                        .withOpacity(0.8),
                                                  ))
                                              : IconButton(
                                                  onPressed: () {
                                                    cart.decrease(product);
                                                  },
                                                  icon: Icon(
                                                    FontAwesomeIcons.minus,
                                                    size: 16,
                                                    color: Colors.blueGrey[100]!
                                                        .withOpacity(0.8),
                                                  )),
                                          Text(
                                            product.qty.toString(),
                                            style: TextStyle(
                                                color: product.qty ==
                                                        product.quantity
                                                    ? Colors.red[500]!
                                                        .withOpacity(0.8)
                                                    : Colors.blueGrey[100]!
                                                        .withOpacity(0.8),
                                                fontWeight: product.qty ==
                                                        product.quantity
                                                    ? FontWeight.normal
                                                    : FontWeight.w600,
                                                fontSize: 18,
                                                fontFamily: 'Acme',
                                                letterSpacing: 1),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                product.qty == product.quantity
                                                    ? null
                                                    : cart.increase(product);
                                              },
                                              icon: Icon(
                                                FontAwesomeIcons.plus,
                                                size: 16,
                                                color: product.qty ==
                                                        product.quantity
                                                    ? Colors.blueGrey[100]!
                                                        .withOpacity(0.2)
                                                    : Colors.blueGrey[100]!
                                                        .withOpacity(0.8),
                                              )),
                                        ],
                                      ),
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
