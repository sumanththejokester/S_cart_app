import 'package:flutter/material.dart';
import 'package:multi_store_app/models/wishlistitems.dart';
import 'package:multi_store_app/provider/wishlistprovider.dart';
import 'package:multi_store_app/widgets/CupertinoDialog.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';
import 'package:provider/provider.dart';

class CustumerWishListScreen extends StatefulWidget {
  const CustumerWishListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CustumerWishListScreen> createState() => _CustumerWishListScreenState();
}

class _CustumerWishListScreenState extends State<CustumerWishListScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            //leading: AppBarBackButton(),
            elevation: 0,
            backgroundColor: Colors.white,
            leading: AppBarBackButton(),
            title: const AppBarTitle(title: 'Wishlist'),
            actions: [
              context.watch<WishList>().getWishItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyCupertinoAlertDialog.showMyCupertinoDialog(
                            context: context,
                            title: 'Clear WishList',
                            content: 'Are You Sure to Clear WishList ?',
                            tapNo: () {
                              Navigator.pop(context);
                            },
                            tapYes: () {
                              context.read<WishList>().clearWishlist();
                              Navigator.pop(context);
                            });
                      },
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.blueGrey[900],
                      ))
            ],
          ),
          body: context.watch<WishList>().getWishItems.isNotEmpty
              ? const WishListItems()
              : const EmptyWishlist(),
        ),
      ),
    );
  }
}

class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Center(
            child: Text(
          'No Items in WishList',
          style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Acme',
              letterSpacing: 1.5),
        )),
      ],
    ));
  }
}
