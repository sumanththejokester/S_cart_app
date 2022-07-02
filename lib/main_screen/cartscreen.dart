import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screen/placeorderscreen.dart';
import 'package:multi_store_app/models/cartitems.dart';
import 'package:multi_store_app/widgets/CupertinoDialog.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';
import 'package:provider/provider.dart';
import '../provider/cartprovider.dart';

class CartScreen extends StatefulWidget {
  final Widget? back;
  const CartScreen({Key? key, this.back}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            //leading: AppBarBackButton(),
            elevation: 0,
            backgroundColor: Colors.white,
            leading: widget.back,
            title: const AppBarTitle(title: 'Cart'),
            actions: [
              context.watch<Cart>().getItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyCupertinoAlertDialog.showMyCupertinoDialog(
                            context: context,
                            title: 'Clear Cart',
                            content: 'Are You Sure to Clear Cart ?',
                            tapNo: () {
                              Navigator.pop(context);
                            },
                            tapYes: () {
                              context.read<Cart>().clearCart();
                              Navigator.pop(context);
                            });
                      },
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.blueGrey[900],
                      ))
            ],
          ),
          body: context.watch<Cart>().getItems.isNotEmpty
              ? const CartItems()
              : const EmptyCart(),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total :  Rs. ',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      context.watch<Cart>().totalprice.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent),
                    ),
                  ],
                ),
                Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[700],
                        borderRadius: BorderRadius.circular(15)),
                    child: MaterialButton(
                      onPressed: context.watch<Cart>().totalprice == 0.0
                          ? () {}
                          : () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PlaceOrderScreen()));
                            },
                      child: Text(
                        'Check Out',
                        style: TextStyle(
                            fontSize: 20,
                            color: context.watch<Cart>().totalprice == 0.0
                                ? Colors.blueGrey[400]
                                : Colors.white),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Nothing In Your Cart !',
          style: TextStyle(fontSize: 30),
        ),
        const SizedBox(
          height: 50,
        ),
        Material(
          color: Colors.blueGrey[900],
          borderRadius: BorderRadius.circular(15),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width * 0.6,
            onPressed: () {
              Navigator.canPop(context)
                  ? Navigator.pop(context)
                  : Navigator.pushReplacementNamed(
                      context, '/custumer_home_screen');
            },
            child: const Text('Continue Shopping',
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        )
      ],
    ));
  }
}
