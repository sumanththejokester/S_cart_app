// ignore_for_file: non_constant_identifier_names, unused_import

import 'package:flutter/material.dart';
import 'package:multi_store_app/utilities/categ_list.dart';
import '../widgets/categorywidgets.dart';

List<String> _8kids = [
  'Girls Sets',
  'Girls Dress',
  'Girls Top',
  'Girls Pants',
  'Jacket',
  'Sweat Shirts',
  'Boys Sets',
  'Boys Top',
  'Boys Pants',
  'Home Wear',
  'Boys Suits',
  'Baby Shoes',
  'Other'
];

class KidsCategory extends StatelessWidget {
  const KidsCategory({Key? key}) : super(key: key);

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
                    headerLabel: 'KIDS',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.63,
                    child: GridView.count(
                      mainAxisSpacing: 50,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: List.generate(_8kids.length, (index) {
                        return Column(
                          children: [
                            SubCategoryModel(
                              mainCategoryName: 'Kids',
                              subCategoryName: _8kids[index],
                              assetName: 'images/kids/kids$index.jpg',
                            ),
                            Text(_8kids[index])
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
              MainCategoryName: 'KIDS',
            ))
      ]),
    );
  }
}
