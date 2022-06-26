import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screen/editproductsceen.dart';
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
        child: Stack(children: [
          Container(
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
                        image:
                            NetworkImage(widget.products['productimages'][0]),
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
                          Row(
                            children: [
                              Text(
                                (' ₹  '),
                                style: TextStyle(
                                    color: Colors.red[900],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(widget.products['price'].toString(),
                                  style: widget.products['discount'] != 0
                                      ? TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          decoration:
                                              TextDecoration.lineThrough)
                                      : TextStyle(
                                          color: Colors.red[900],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                              SizedBox(
                                width: 5,
                              ),
                              widget.products['discount'] != 0
                                  ? Text(
                                      ((1 -
                                                  (widget.products['discount'] /
                                                      100)) *
                                              (widget.products['price']))
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          color: Colors.red[900],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16))
                                  : Text('')
                            ],
                          ),
                          widget.products['sid'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditProduct(
                                                  items: widget.products,
                                                )));
                                  },
                                  icon: Icon(Icons.edit_outlined),
                                  color: Colors.blueGrey,
                                )
                              : IconButton(
                                  onPressed: () {
                                    context
                                                .read<WishList>()
                                                .getWishItems
                                                .firstWhereOrNull((product) =>
                                                    product.documentId ==
                                                    widget.products[
                                                        'productid']) !=
                                            null
                                        ? context.read<WishList>().removethis(
                                            widget.products['productid'])
                                        : context
                                            .read<WishList>()
                                            .addWishlistItem(
                                                widget.products['productname'],
                                                widget.products['discount'] != 0
                                                    ? ((1 -
                                                            (widget.products[
                                                                    'discount'] /
                                                                100)) *
                                                        (widget
                                                            .products['price']))
                                                    : widget.products['price'],
                                                1,
                                                widget.products['instock'],
                                                widget
                                                    .products['productimages'],
                                                widget.products['productid'],
                                                widget.products['sid']);
                                  },
                                  icon: context
                                              .watch<WishList>()
                                              .getWishItems
                                              .firstWhereOrNull((product) =>
                                                  product.documentId ==
                                                  widget
                                                      .products['productid']) !=
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
          widget.products['discount'] != 0
              ? Positioned(
                  top: 25,
                  left: 0,
                  child: Container(
                    height: 25,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[300],
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Center(
                        child: Text(
                            'Save  ${widget.products['discount'].toString()} %')),
                  ),
                )
              : SizedBox()
        ]),
      ),
    );
  }
}
