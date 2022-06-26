import 'dart:io';
import 'package:expandable/expandable.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/utilities/categ_list.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';
import 'package:path/path.dart' as path;
import 'package:multi_store_app/widgets/snackbar.dart';

class EditProduct extends StatefulWidget {
  final dynamic items;

  const EditProduct({Key? key, required this.items}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late double price;
  late int quantity;
  late String productName;
  late String productDescription;
  late String productId;
  int? discount = 0;
  bool processing = false;
  String mainCategoryValue = 'Select Category';
  String subCategoryValue = 'Select SubCategory';
  List<String> subcateg = [];
  List<dynamic> imagesUrlList = [];

  Future uploadimages() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (imagesFileList!.isNotEmpty) {
        if (mainCategoryValue != 'Select Category' &&
            subCategoryValue != 'Select SubCategory') {
          try {
            for (var image in imagesFileList!) {
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref('products/${path.basename(image.path)}');

              await ref.putFile(File(image.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  imagesUrlList.add(value);
                });
              });
            }
          } catch (e) {
            MyMessageBuilder.showSnackBar(
                _scaffoldKey, 'Couldn\'t Product Upload');
          }
        } else {
          MyMessageBuilder.showSnackBar(
              _scaffoldKey, 'Please select Categories too');
        }
      } else {
        imagesUrlList = widget.items['productimages'];
      }
    }
  }

  editproductdata() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('products')
          .doc(widget.items['productid']);
      transaction.update(documentReference, {
        'maincateg': mainCategoryValue,
        'subcateg': subCategoryValue,
        'price': price,
        'instock': quantity,
        'productname': productName,
        'productdescription': productDescription,
        'productimages': imagesUrlList,
        'discount': discount,
      });
    }).whenComplete(() {
      Navigator.pop(context);
    });
  }

  savechanges() async {
    await uploadimages().whenComplete(() {
      editproductdata();
    });
  }

  List<XFile>? imagesFileList = [];
  dynamic _pickedImageError;

  CollectionReference suppliers =
      FirebaseFirestore.instance.collection('suppliers');

  void pickProductImages() async {
    try {
      final pickedImages = await ImagePicker()
          .pickMultiImage(maxHeight: 300, maxWidth: 300, imageQuality: 95);
      setState(() {
        imagesFileList = pickedImages!;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
    }
  }

  Widget previewImages() {
    if (imagesFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: imagesFileList!.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Image.file(
              File(imagesFileList![index].path),
            );
          });
    } else {
      return Center(
          child: InkWell(
        child: const Text('Pick Images of Product'),
        onTap: () {
          pickProductImages();
        },
      ));
    }
  }

  Widget previewcurrentImages() {
    List<dynamic> itemimages = widget.items['productimages'];
    return ListView.builder(
        itemCount: itemimages.length,
        itemBuilder: ((context, index) {
          return Image.network(itemimages[index]);
        }));
  }

  void selectedMainCateg(String? value) {
    if (value == 'Select Category') {
      subcateg = [];
    } else if (value == 'Men') {
      subcateg = men;
    } else if (value == 'Women') {
      subcateg = women;
    } else if (value == 'Electronics') {
      subcateg = electronics;
    } else if (value == 'Accessories') {
      subcateg = accessories;
    } else if (value == 'Shoes') {
      subcateg = shoes;
    } else if (value == 'Home & Garden') {
      subcateg = homeandgarden;
    } else if (value == 'Beauty') {
      subcateg = beauty;
    } else if (value == 'Kids') {
      subcateg = kids;
    } else if (value == 'Bags') {
      subcateg = bags;
    }
    setState(() {
      mainCategoryValue = value!;
      subCategoryValue = 'Select SubCategory';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit Products',
                style: TextStyle(color: Colors.blueGrey[900]),
              ),
              Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 0.20,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[700],
                      borderRadius: BorderRadius.circular(15)),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  )),
              Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 0.20,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[700],
                      borderRadius: BorderRadius.circular(15)),
                  child: MaterialButton(
                    onPressed: () {
                      savechanges();
                    },
                    child: Text(
                      'Save',
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  )),
            ],
          ),
          elevation: 0,
          backgroundColor: Colors.blueGrey[100],
          leading: AppBarBackButton(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ExpandablePanel(
                    theme: ExpandableThemeData(hasIcon: false),
                    header: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Edit Product Images And Category',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    collapsed: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 38, 50, 56)),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(17.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.blueGrey[100],
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 38, 50, 56)),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.width * 0.4,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),

                                      //decoration: BoxDecoration(

                                      //   borderRadius:
                                      //      BorderRadius.circular(15)),
                                      child: previewcurrentImages())),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8, 14, 8, 8),
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.12,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 38, 50, 56)),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(1.5),
                                          child: Text(
                                            'Current Category: ' +
                                                widget.items['maincateg'],
                                            style: TextStyle(
                                                color: Colors.blueGrey[900],
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.12,
                                    width: MediaQuery.of(context).size.width *
                                        0.42,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 38, 50, 56)),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 1.2, vertical: 1.8),
                                          child: Text(
                                            'Current Category: ' +
                                                widget.items['subcateg'],
                                            style: TextStyle(
                                                color: Colors.blueGrey[900],
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    expanded: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 38, 50, 56)),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(17.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.blueGrey[100],
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 38, 50, 56)),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.width * 0.4,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),

                                      //decoration: BoxDecoration(

                                      //   borderRadius:
                                      //      BorderRadius.circular(15)),
                                      child: InkWell(
                                        onTap: () {
                                          pickProductImages();
                                        },
                                        child: imagesFileList != null
                                            ? previewImages()
                                            : Center(
                                                child: Text(
                                                    'Pick Images of Product')),
                                      ))),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8, 14, 8, 8),
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.18,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 38, 50, 56)),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0.4),
                                          child: Text(
                                            'Select Main Category',
                                            style: TextStyle(
                                                color: Colors.blueGrey[900],
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                        DropdownButton(
                                            dropdownColor: Colors.blueGrey[100],
                                            value: mainCategoryValue,
                                            items: maincateg
                                                .map<DropdownMenuItem<String>>(
                                                    (value) {
                                              return DropdownMenuItem(
                                                child: Text(value),
                                                value: value,
                                              );
                                            }).toList(),
                                            onChanged: (String? value) {
                                              selectedMainCateg(value);
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.18,
                                    width: MediaQuery.of(context).size.width *
                                        0.44,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 38, 50, 56)),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0.4),
                                          child: Text(
                                            'Select Sub Category',
                                            style: TextStyle(
                                                color: Colors.blueGrey[900],
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                        DropdownButton(
                                            dropdownColor: Colors.blueGrey[100],
                                            iconDisabledColor:
                                                Colors.blueGrey[100],
                                            iconEnabledColor:
                                                Colors.blueGrey[400],
                                            menuMaxHeight: 500,
                                            disabledHint:
                                                const Text('Select Category'),
                                            value: subCategoryValue,
                                            items: subcateg
                                                .map<DropdownMenuItem<String>>(
                                                    (value) {
                                              return DropdownMenuItem(
                                                child: Text(value),
                                                value: value,
                                              );
                                            }).toList(),
                                            onChanged: (String? value) {
                                              setState(() {
                                                subCategoryValue = value!;
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      border: Border.all(
                          color: const Color.fromARGB(255, 38, 50, 56)),
                    ),
                    height: MediaQuery.of(context).size.height * 0.533,
                    width: MediaQuery.of(context).size.width * 0.96,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.47,
                                  child: TextFormField(
                                    initialValue:
                                        widget.items['price'].toString(),
                                    validator: ((value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter Price of Product';
                                      } else if (value.isValidPrice() != true) {
                                        return 'Please Enter Valid Price';
                                      }
                                      return null;
                                    }),
                                    onSaved: (value) {
                                      price = double.parse(value!);
                                    },
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: textFormDercoration().copyWith(
                                        labelText: 'Price', hintText: 'Rs.'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.27,
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  child: TextFormField(
                                    initialValue:
                                        widget.items['discount'].toString(),
                                    maxLength: 2,
                                    validator: ((value) {
                                      if (value!.isEmpty) {
                                        null;
                                      } else if (value.isValidDiscount() !=
                                          true) {
                                        return 'Invalid Discount';
                                      }
                                      return null;
                                    }),
                                    onSaved: (value) {
                                      discount = int.parse(value!);
                                    },
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: textFormDercoration().copyWith(
                                        labelText: 'Discount',
                                        hintText: 'discount ..%'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 18),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.52,
                              child: TextFormField(
                                initialValue:
                                    widget.items['instock'].toString(),
                                validator: ((value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Quantity of Product';
                                  } else if (value.isValidQuantity() != true) {
                                    return 'Please Enter Valid Quantity';
                                  }
                                  return null;
                                }),
                                onSaved: (value) {
                                  quantity = int.parse(value!);
                                },
                                keyboardType: TextInputType.number,
                                decoration: textFormDercoration().copyWith(
                                    labelText: 'Quantity',
                                    hintText: 'Add Quantity'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.92,
                              child: TextFormField(
                                initialValue: widget.items['productname'],
                                validator: ((value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter The Name of the Product';
                                  }
                                  return null;
                                }),
                                onSaved: (value) {
                                  productName = value!;
                                },
                                maxLength: 100,
                                maxLines: 1,
                                decoration: textFormDercoration().copyWith(
                                    labelText: 'Product Name',
                                    hintText: 'Enter name of Product'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.92,
                              child: TextFormField(
                                initialValue:
                                    widget.items['productdescription'],
                                validator: ((value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Description of the Product';
                                  }
                                  return null;
                                }),
                                onSaved: (value) {
                                  productDescription = value!;
                                },
                                maxLength: 700,
                                maxLines: 3,
                                decoration: textFormDercoration().copyWith(
                                    labelText: 'Description',
                                    hintText: 'Add Description of the Product'),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await FirebaseFirestore.instance.runTransaction(
              (transaction) async {
                DocumentReference documentReference = FirebaseFirestore.instance
                    .collection('products')
                    .doc(widget.items['productid']);
                transaction.delete(documentReference);
              },
            ).whenComplete(() => Navigator.pop(context));
          },
          backgroundColor: Colors.blueGrey,
          child: const Icon(Icons.delete_outlined),
        ),
      ),
    );
  }

  InputDecoration textFormDercoration() {
    return InputDecoration(
        labelText: 'Price',
        hintText: 'Rs.',
        labelStyle: TextStyle(color: Colors.blueGrey[900]),
        hintStyle: TextStyle(color: Colors.blueGrey[900]?.withOpacity(0.7)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blueGrey, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 207, 216, 220), width: 2)));
  }
}

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^[1-9][0-9]*[\.]*[0-9]{0,2}$').hasMatch(this);
  }
}

extension DiscountValidator on String {
  bool isValidDiscount() {
    return RegExp(r'^([0-9]*)$').hasMatch(this);
  }
}
