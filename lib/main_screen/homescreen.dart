// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/galleries/accessoriesgallery.dart';
import 'package:multi_store_app/galleries/bagsgallery.dart';
import 'package:multi_store_app/galleries/beautygallery.dart';
import 'package:multi_store_app/galleries/electronicsgallery.dart';
import 'package:multi_store_app/galleries/home&gardengallery.dart';
import 'package:multi_store_app/galleries/kidsgallery.dart';
import 'package:multi_store_app/galleries/mengallery.dart';
import 'package:multi_store_app/galleries/shoesgallery.dart';
import 'package:multi_store_app/galleries/womengallery.dart';

import '../widgets/searchbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100]!.withOpacity(0.5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const SearchBar(),
          bottom: const TabBar(
              isScrollable: true,
              indicatorColor: Colors.black,
              tabs: [
                RepeatedTab(
                  label: 'Men',
                ),
                RepeatedTab(
                  label: 'Women',
                ),
                RepeatedTab(
                  label: 'Shoes',
                ),
                RepeatedTab(
                  label: 'Bags',
                ),
                RepeatedTab(
                  label: 'Electronics',
                ),
                RepeatedTab(
                  label: 'Accessories',
                ),
                RepeatedTab(
                  label: 'Home & Garden',
                ),
                RepeatedTab(
                  label: 'Kids',
                ),
                RepeatedTab(
                  label: 'Beauty',
                ),
              ]),
        ),
        body: const TabBarView(children: [
          MenGalleryScreen(),
          WomenGalleryScreen(),
          ShoesGalleryScreen(),
          BagsGalleryScreen(),
          ElectronicsGalleryScreen(),
          AccessoriesGalleryScreen(),
          HomeGardenGalleryScreen(),
          KidsGalleryScreen(),
          BeautyGalleryScreen(),
        ]),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        label,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
