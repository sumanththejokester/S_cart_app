import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screen/searchscreen.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const SearchScreen())));
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
            border:
                Border.all(color: const Color.fromARGB(255, 3, 36, 52), width: 1.4),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.search,
                    color: Colors.blueGrey[900],
                  ),
                ),
                const Text(
                  'Search in S Cart...',
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                ),
              ],
            ),
            Container(
              height: 32,
              width: 75,
              decoration: BoxDecoration(
                  color: Colors.blueGrey[900],
                  borderRadius: BorderRadius.circular(20)),
              child: const Center(
                child: Text(
                  'Search',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
