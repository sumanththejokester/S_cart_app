// ignore_for_file: unused_import, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:multi_store_app/categories/accessoriescategory.dart';
import 'package:multi_store_app/categories/bagscategory.dart';
import 'package:multi_store_app/categories/beautycategory.dart';
import 'package:multi_store_app/categories/electronicscategory.dart';
import 'package:multi_store_app/categories/home&gardencategory.dart';
import 'package:multi_store_app/categories/kidscategory.dart';
import 'package:multi_store_app/categories/mencategory.dart';
import 'package:multi_store_app/categories/shoescategory.dart';
import 'package:multi_store_app/categories/womencategory.dart';
import 'package:multi_store_app/utilities/categ_list.dart';
import 'package:multi_store_app/widgets/searchbar.dart';

import '../widgets/searchbar.dart';

List<ItemsData> items = [
  ItemsData(label: 'Men'),
  ItemsData(label: 'Women'),
  ItemsData(label: 'Shoes'),
  ItemsData(label: 'Bags'),
  ItemsData(label: 'Electronics'),
  ItemsData(label: 'Accessories'),
  ItemsData(label: 'Home&Garden'),
  ItemsData(label: 'Kids'),
  ItemsData(label: 'Beauty'),
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final PageController _pageController = PageController();
  @override
  void initState() {
    for (var element in items) {
      element.isSelected = false;
    }
    setState(() {
      items[0].isSelected = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const SearchBar(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned(
              bottom: MediaQuery.of(context).size.width * 0.02,
              left: MediaQuery.of(context).size.width * 0.025,
              child: sideNavigator(size)),
          Positioned(
              bottom: MediaQuery.of(context).size.width * 0.02,
              right: MediaQuery.of(context).size.width * 0.02,
              child: categView(size)),
        ],
      ),
    );
  }

  Widget sideNavigator(Size size) {
    return Container(
      height: size.height * 0.75,
      width: size.width * 0.25,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.blueGrey[300]),
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: (() {
                _pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceOut);
                //for (var element in items) {
                //  element.isSelected = false;
                //}
                //setState(() {
                //  items[index].isSelected = true;
                //});
              }),
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(5),
                    color: items[index].isSelected == true
                        ? Colors.white
                        : Colors.blueGrey[300],
                  ),
                  height: 85,
                  child: Center(child: Text(items[index].label))),
            );
          })),
    );
  }

  Widget categView(Size size) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      height: size.height * 0.75,
      width: size.width * 0.68,
      child: PageView(
        controller: _pageController,
        onPageChanged: ((value) {
          for (var element in items) {
            element.isSelected = false;
          }
          setState(() {
            items[value].isSelected = true;
          });
        }),
        scrollDirection: Axis.vertical,
        children: [
          const MenCategory(),
          const WomenCategory(),
          const ShoesCategory(),
          const BagsCategory(),
          const ElectronicsCategory(),
          const AccessoriesCategory(),
          const HomeGardenCategory(),
          const KidsCategory(),
          const BeautyCategory(),
        ],
      ),
    );
  }
}

class ItemsData {
  String label;
  bool isSelected;
  ItemsData({required this.label, this.isSelected = false});
}
