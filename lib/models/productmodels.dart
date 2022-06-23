import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screen/productscreen.dart';
import 'package:multi_store_app/provider/wishlistprovider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProductModel extends StatefulWidget {
  final dynamic products;
  const ProductModel({Key? key, required this.products}) : super(key: key);

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductScreen(
                      prolist: widget.products,
                    )),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color.fromARGB(255, 24, 81, 110)),
          ),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    constraints: const BoxConstraints(
                        maxHeight: 200, minHeight: 100, minWidth: 150),
                    child: Image(
                      image: NetworkImage(widget.products['productimages'][0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Text(
                      widget.products['productname'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.blueGrey[900],
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: 'Acme',
                          letterSpacing: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          (' ₹  ') + widget.products['price'].toString(),
                          style:
                              TextStyle(color: Colors.red[900], fontSize: 16),
                        ),
                        widget.products['sid'] ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.edit_note),
                                color: Colors.red[900],
                              )
                            : IconButton(
                                onPressed: () {
                                  context
                                              .read<WishList>()
                                              .getWishItems
                                              .firstWhereOrNull((product) =>
                                                  product.documentId ==
                                                  widget
                                                      .products['productid']) !=
                                          null
                                      ? context.read<WishList>().removethis(
                                          widget.products['productid'])
                                      : context
                                          .read<WishList>()
                                          .addWishlistItem(
                                              widget.products['productname'],
                                              widget.products['price'],
                                              1,
                                              widget.products['instock'],
                                              widget.products['productimages'],
                                              widget.products['productid'],
                                              widget.products['sid']);
                                },
                                icon: context
                                            .watch<WishList>()
                                            .getWishItems
                                            .firstWhereOrNull((product) =>
                                                product.documentId ==
                                                widget.products['productid']) !=
                                        null
                                    ? Icon(Icons.favorite)
                                    : Icon(Icons.favorite_border_outlined),
                                color: Colors.redAccent,
                              )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
