import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/utilities/categ_list.dart';
import 'package:path/path.dart' as path;
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:uuid/uuid.dart';

class UploadProduct extends StatefulWidget {
  const UploadProduct({Key? key}) : super(key: key);

  @override
  State<UploadProduct> createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
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
  List<String> imagesUrlList = [];

  Future<void> uploadImages() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (imagesFileList!.isNotEmpty) {
        setState(() {
          processing = true;
        });
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
        MyMessageBuilder.showSnackBar(_scaffoldKey, 'Please pick Images too');
      }
    } else {
      MyMessageBuilder.showSnackBar(_scaffoldKey, 'Please fill All Fields');
    }
  }

  void uploadData() async {
    if (imagesUrlList.isNotEmpty) {
      CollectionReference productRef =
          FirebaseFirestore.instance.collection('products');
      productId = const Uuid().v4();
      await productRef.doc(productId).set({
        'productid': productId,
        'maincateg': mainCategoryValue,
        'subcateg': subCategoryValue,
        'price': price,
        'instock': quantity,
        'productname': productName,
        'productdescription': productDescription,
        'sid': FirebaseAuth.instance.currentUser!.uid,
        'productimages': imagesUrlList,
        'discount': discount,
      }).whenComplete(() {
        setState(() {
          processing = false;
          imagesFileList = [];
          mainCategoryValue = 'Select Category';
          subcateg = [];
          imagesUrlList = [];
        });
        _formKey.currentState!.reset();
        MyMessageBuilder.showSnackBar(
            _scaffoldKey, 'Product Uploaded Successfully');
      });
    } else {
      // ignore: avoid_print
      print('no images');
    }
  }

  void uploadProduct() async {
    await uploadImages().whenComplete(() {
      uploadData();
    });
  }

  List<XFile>? imagesFileList = [];
  // ignore: unused_field
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
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  //color: Colors.blueGrey[100],
                  border:
                      Border.all(color: const Color.fromARGB(255, 38, 50, 56)),
                ),
                height: MediaQuery.of(context).size.height * 0.827,
                width: MediaQuery.of(context).size.width * 0.96,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),

                                  //decoration: BoxDecoration(

                                  //   borderRadius:
                                  //      BorderRadius.circular(15)),
                                  child: imagesFileList != null
                                      ? previewImages()
                                      : Center(
                                          child: InkWell(
                                          child: const Text(
                                              'Pick Images of Product'),
                                          onTap: () {
                                            pickProductImages();
                                          },
                                        )),
                                )),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.18,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 38, 50, 56)),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  height:
                                      MediaQuery.of(context).size.width * 0.18,
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 38, 50, 56)),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          color: Colors.blueGrey,
                          thickness: 1,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.47,
                              child: TextFormField(
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.09,
                              width: MediaQuery.of(context).size.width * 0.27,
                              child: TextFormField(
                                maxLength: 2,
                                validator: ((value) {
                                  if (value!.isEmpty) {
                                    null;
                                  } else if (value.isValidDiscount() != true) {
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
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.52,
                          child: TextFormField(
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
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            imagesFileList!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          imagesFileList = [];
                        });
                      },
                      backgroundColor: Colors.blueGrey,
                      child: const Icon(Icons.delete_forever_outlined),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        pickProductImages();
                      },
                      backgroundColor: Colors.blueGrey,
                      child: const Icon(Icons.photo_library),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: FloatingActionButton(
                  onPressed: processing == true
                      ? null
                      : () {
                          uploadProduct();
                        },
                  backgroundColor: Colors.blueGrey,
                  child: processing == true
                      ? const CircularProgressIndicator(
                          color: Color.fromARGB(255, 207, 216, 220),
                        )
                      : const Icon(
                          Icons.upload_sharp,
                        )),
            )
          ],
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
