import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:multi_store_app/main_screen/cartscreen.dart';
import 'package:multi_store_app/main_screen/store.dart';
import 'package:multi_store_app/minor_screen/fullscreenimage.dart';
import 'package:multi_store_app/models/productmodels.dart';
import 'package:multi_store_app/provider/cartprovider.dart';
import 'package:multi_store_app/provider/wishlistprovider.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';
import 'package:multi_store_app/widgets/button.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:collection/collection.dart';

class ProductScreen extends StatefulWidget {
  final dynamic prolist;
  const ProductScreen({Key? key, required this.prolist}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imagesList = widget.prolist['productimages'];

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincateg', isEqualTo: widget.prolist['maincateg'])
        .where('subcateg', isEqualTo: widget.prolist['subcateg'])
        .snapshots();
    final Stream<QuerySnapshot> reviewsStream = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.prolist['productid'])
        .collection('reviews')
        .snapshots();
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        //backgroundColor: Colors.blueGrey[100]!.withOpacity(0.5),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              //height: MediaQuery.of(context).size.height * 0.8295,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                //border: Border.all(color: Color.fromARGB(255, 41, 55, 62))
              ),
              child: Column(children: [
                Stack(children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullScreenImageScreen(
                                        imagesList: imagesList,
                                      )));
                        },
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Swiper(
                              pagination: const SwiperPagination(
                                builder: SwiperPagination.dots,
                              ),
                              itemBuilder: (context, index) {
                                return Image(
                                  image: NetworkImage(imagesList[index]),
                                );
                              },
                              itemCount: imagesList.length),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      left: 2,
                      top: 40,
                      child: CircleAvatar(
                        backgroundColor: Colors.blueGrey.withOpacity(0.5),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )),
                  Positioned(
                      right: 2,
                      top: 40,
                      child: CircleAvatar(
                        backgroundColor: Colors.blueGrey.withOpacity(0.5),
                        child: IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ))
                ]),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: Text(
                        widget.prolist['productname'],
                        style: TextStyle(
                            color: Colors.blueGrey[900],
                            fontFamily: 'Acme',
                            letterSpacing: 1.5,
                            fontSize: 24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            (' ₹     '),
                            style: TextStyle(
                                color: Colors.red[900],
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(widget.prolist['price'].toString(),
                              style: widget.prolist['discount'] != 0
                                  ? const TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 18,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w600)
                                  : TextStyle(
                                      color: Colors.red[900],
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                          const SizedBox(
                            width: 15,
                          ),
                          widget.prolist['discount'] != 0
                              ? Text(
                                  ((1 - (widget.prolist['discount'] / 100)) *
                                          (widget.prolist['price']))
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                      color: Colors.red[900],
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600))
                              : const Text('')
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          context
                                      .read<WishList>()
                                      .getWishItems
                                      .firstWhereOrNull((product) =>
                                          product.documentId ==
                                          widget.prolist['productid']) !=
                                  null
                              ? context
                                  .read<WishList>()
                                  .removethis(widget.prolist['productid'])
                              : context.read<WishList>().addWishlistItem(
                                  widget.prolist['productname'],
                                  widget.prolist['discount'] != 0
                                      ? ((1 -
                                              (widget.prolist['discount'] /
                                                  100)) *
                                          (widget.prolist['price']))
                                      : widget.prolist['price'],
                                  1,
                                  widget.prolist['instock'],
                                  widget.prolist['productimages'],
                                  widget.prolist['productid'],
                                  widget.prolist['sid']);
                        },
                        icon: context
                                    .watch<WishList>()
                                    .getWishItems
                                    .firstWhereOrNull((product) =>
                                        product.documentId ==
                                        widget.prolist['productid']) !=
                                null
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border_outlined),
                        color: Colors.redAccent,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      widget.prolist['instock'] == 0
                          ? const Text(
                              'Out of Stock',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 239, 101, 55),
                                  fontSize: 16),
                            )
                          : Text(
                              (widget.prolist['instock']).toString() +
                                  (' Available in Stock'),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 59, 159, 209),
                                  fontSize: 16),
                            ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        SizedBox(
                          height: 40,
                          width: 50,
                          child: Divider(
                            color: Colors.blueGrey,
                            thickness: 1,
                          ),
                        ),
                        Text(
                          ('Product Description'),
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 40,
                          width: 50,
                          child: Divider(
                            color: Colors.blueGrey,
                            thickness: 1,
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          widget.prolist['productdescription'],
                          textScaleFactor: 1.1,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                reviews(reviewsStream),
                SizedBox(
                    height: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            SizedBox(
                              height: 40,
                              width: 50,
                              child: Divider(
                                color: Colors.blueGrey,
                                thickness: 1,
                              ),
                            ),
                            Text(
                              ('Recommended Products'),
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 40,
                              width: 50,
                              child: Divider(
                                color: Colors.blueGrey,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                SizedBox(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _productsStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text(
                          'This Category has no Items',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Acme',
                              letterSpacing: 1.5),
                        ));
                      }

                      return SingleChildScrollView(
                        child: StaggeredGridView.countBuilder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          crossAxisCount: 2,
                          itemBuilder: (context, index) {
                            return ProductModel(
                              products: snapshot.data!.docs[index],
                            );
                          },
                          staggeredTileBuilder: (context) =>
                              const StaggeredTile.fit(1),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                )
              ]),
            ),
          ),
        ),
        bottomSheet: Container(
          color: Colors.blueGrey[100],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Store(suppId: widget.prolist['sid']),
                              ));
                        },
                        icon: const Icon(Icons.store)),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CartScreen(
                                        back: AppBarBackButton(),
                                      )));
                        },
                        icon: Badge(
                            showBadge: context.read<Cart>().getItems.isEmpty
                                ? false
                                : true,
                            animationType: BadgeAnimationType.slide,
                            badgeColor:
                                const Color.fromARGB(255, 152, 189, 205),
                            badgeContent: Text(
                              context.watch<Cart>().getItems.length.toString(),
                              style: TextStyle(
                                  color: Colors.blueGrey[900],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                            child: const Icon(Icons.shopping_cart))),
                  ],
                ),
                Button(
                    buttonlabel: context.read<Cart>().getItems.firstWhereOrNull(
                                (product) =>
                                    product.documentId ==
                                    widget.prolist['productid']) !=
                            null
                        ? 'Added to Cart'
                        : 'Add to Cart',
                    onPressed: () {
                      if (widget.prolist['instock'] == 0) {
                        MyMessageBuilder.showSnackBar(
                            _scaffoldKey, 'Item Ou of Stock');
                      } else if (context.read<Cart>().getItems.firstWhereOrNull(
                              (product) =>
                                  product.documentId ==
                                  widget.prolist['productid']) !=
                          null) {
                        MyMessageBuilder.showSnackBar(
                            _scaffoldKey, 'Item Already in Cart');
                      } else {
                        context.read<Cart>().addItem(
                            widget.prolist['productname'],
                            widget.prolist['discount'] != 0
                                ? ((1 - (widget.prolist['discount'] / 100)) *
                                    (widget.prolist['price']))
                                : widget.prolist['price'],
                            1,
                            widget.prolist['instock'],
                            widget.prolist['productimages'],
                            widget.prolist['productid'],
                            widget.prolist['sid']);
                      }
                    },
                    buttonwidth: 0.5)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget reviews(var reviewsStream) {
  return ExpandablePanel(
      header: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Reviews',
          style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      collapsed: SizedBox(
        height: 150,
        child: allreviews(reviewsStream),
      ),
      expanded: allreviews(reviewsStream));
}

Widget allreviews(var reviewsStream) {
  return StreamBuilder<QuerySnapshot>(
    stream: reviewsStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
      if (snapshot2.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot2.data!.docs.isEmpty) {
        return const Center(
            child: Text(
          'This Product has no Reviews',
          style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Acme',
              letterSpacing: 1.5),
        ));
      }

      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot2.data!.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(snapshot2.data!.docs[index]['profileimage']),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(snapshot2.data!.docs[index]['name']),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                            snapshot2.data!.docs[index]['rate'].toString()),
                      ),
                      (snapshot2.data!.docs[index]['rate'] < 1.5)
                          ? const Icon(
                              Icons.sentiment_very_dissatisfied,
                              color: Colors.red,
                            )
                          : ((snapshot2.data!.docs[index]['rate'] > 1) &&
                                  (snapshot2.data!.docs[index]['rate'] < 2.5))
                              ? const Icon(
                                  Icons.sentiment_dissatisfied,
                                  color: Colors.redAccent,
                                )
                              : ((snapshot2.data!.docs[index]['rate'] > 2) &&
                                      (snapshot2.data!.docs[index]['rate'] <
                                          3.5))
                                  ? const Icon(
                                      Icons.sentiment_neutral,
                                      color: Colors.amber,
                                    )
                                  : ((snapshot2.data!.docs[index]['rate'] >
                                              3) &&
                                          (snapshot2.data!.docs[index]['rate'] <
                                              4.5))
                                      ? const Icon(
                                          Icons.sentiment_satisfied,
                                          color: Colors.lightGreen,
                                        )
                                      : const Icon(
                                          Icons.sentiment_very_satisfied,
                                          color: Colors.green,
                                        ),
                    ],
                  )
                ],
              ),
              subtitle: Text(snapshot2.data!.docs[index]['comment']),
            );
          });
    },
  );
}
