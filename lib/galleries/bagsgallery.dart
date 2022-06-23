import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/models/productmodels.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class BagsGalleryScreen extends StatefulWidget {
  const BagsGalleryScreen({Key? key}) : super(key: key);

  @override
  State<BagsGalleryScreen> createState() => _BagsGalleryScreenState();
}

class _BagsGalleryScreenState extends State<BagsGalleryScreen> {
  final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: 'Bags')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
          ),
        );
      },
    );
  }
}
