import 'package:flutter/material.dart';

import '../minor_screen/subcategoryproducts.dart';

class SliderBar extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final String MainCategoryName;
  // ignore: non_constant_identifier_names
  const SliderBar({Key? key, required this.MainCategoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width * 0.05,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blueGrey[100],
              borderRadius: BorderRadius.circular(5)),
          child: RotatedBox(
              quarterTurns: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      MainCategoryName,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 57, 80, 91),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 10),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

class SubCategoryModel extends StatelessWidget {
  final String mainCategoryName;
  final String subCategoryName;
  final String assetName;
  const SubCategoryModel({
    Key? key,
    required this.mainCategoryName,
    required this.subCategoryName,
    required this.assetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubCategoryProducts(
                      maincategoryname: mainCategoryName,
                      subcategoryname: subCategoryName,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.white),
        height: 100,
        width: 100,
        child: Image(image: AssetImage(assetName)),
      ),
    );
  }
}

class CategoryHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const CategoryHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Text(
        headerLabel,
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
      ),
    );
  }
}
