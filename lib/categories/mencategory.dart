// ignore_for_file: non_constant_identifier_names, unused_import

import 'package:flutter/material.dart';
import 'package:multi_store_app/utilities/categ_list.dart';
import '../widgets/categorywidgets.dart';

List<String> image = [
  'images/men/men0.jpg',
  'images/men/men1.jpg',
  'images/men/men2.jpg',
  'images/men/men3.jpg',
  'images/men/men4.jpg',
  'images/men/men5.jpg',
  'images/men/men6.jpg',
  'images/men/men7.jpg',
  'images/men/men8.jpg'
];
List<String> _1men = [
  'Shirt',
  'T-Shirt',
  'Jacket',
  'Vest',
  'Coat',
  'Jeans',
  'Shorts',
  'Suit',
  'Other',
];

class MenCategory extends StatelessWidget {
  const MenCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Stack(children: [
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0,
          right: MediaQuery.of(context).size.width * 0.05,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width * 0.63,
            child: Container(
              decoration: BoxDecoration(
                  //border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white),
              child: Column(
                children: [
                  const CategoryHeaderLabel(
                    headerLabel: 'MEN',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.63,
                    child: GridView.count(
                      mainAxisSpacing: 50,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: List.generate(_1men.length, (index) {
                        return Column(
                          children: [
                            SubCategoryModel(
                              mainCategoryName: 'Men',
                              subCategoryName: _1men[index],
                              assetName: image[index],
                            ),
                            Text(_1men[index])
                          ],
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const Positioned(
            bottom: 0,
            right: 0,
            child: SliderBar(
              MainCategoryName: 'MEN',
            ))
      ]),
    );
  }
}
