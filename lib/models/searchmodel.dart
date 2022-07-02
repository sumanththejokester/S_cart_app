import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screen/productscreen.dart';

class SearchModel extends StatelessWidget {
  final dynamic e;
  const SearchModel({Key? key, required this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProductScreen(prolist: e)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          height: 100,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image(
                      image: NetworkImage(e['productimages'][0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      e['productname'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.blueGrey[900],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'Acme',
                          letterSpacing: 1),
                    ),
                    Text(
                      e['productdescription'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.blueGrey[600],
                          fontSize: 11,
                          fontFamily: 'Acme',
                          letterSpacing: 1),
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
