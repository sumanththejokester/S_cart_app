// ignore_for_file: non_constant_identifier_names, unused_import, file_names

import 'package:flutter/material.dart';
import 'package:multi_store_app/utilities/categ_list.dart';
import '../widgets/categorywidgets.dart';

List<String> _7homeandgarden = [
  'Living Room',
  'Bed Room',
  'Dinning Room',
  'Kitchen Tools',
  'Bath Access.',
  'Furniture',
  'Decoration',
  'Lighting',
  'Garden',
  'Other'
];

class HomeGardenCategory extends StatelessWidget {
  const HomeGardenCategory({Key? key}) : super(key: key);

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
                    headerLabel: 'HOME GARDEN',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.63,
                    child: GridView.count(
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 5,
                      crossAxisCount: 2,
                      children: List.generate(_7homeandgarden.length, (index) {
                        return Column(
                          children: [
                            SubCategoryModel(
                              mainCategoryName: 'Home & Garden',
                              subCategoryName: _7homeandgarden[index],
                              assetName: 'images/homegarden/home$index.jpg',
                            ),
                            Text(_7homeandgarden[index])
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
              MainCategoryName: 'HOME & GARDEN',
            ))
      ]),
    );
  }
}
