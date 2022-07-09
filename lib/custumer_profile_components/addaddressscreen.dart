import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';
import 'package:multi_store_app/widgets/authscreenwidgets.dart';
import 'package:multi_store_app/widgets/button.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:uuid/uuid.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  late String firstname;
  late String lastname;
  late String mobilenumber;
  String countryValue = 'Choose Country';
  String stateValue = 'Choose State';
  String cityValue = 'Choose City';
  late String faddress;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const AppBarTitle(
            title: 'Add Address',
          ),
          leading: const AppBarBackButton(),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),

              //color: Colors.blueGrey[100],
              gradient: LinearGradient(colors: [
                Colors.blueGrey.withOpacity(0.4),
                const Color.fromARGB(255, 15, 113, 162).withOpacity(0.4),
              ]),
              border: Border.all(color: const Color.fromARGB(255, 38, 50, 56)),
            ),
            height: MediaQuery.of(context).size.height * 0.827,
            width: MediaQuery.of(context).size.width * 0.94,
            child: SingleChildScrollView(
              reverse: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                          child: TextFormField(
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              }),
                              onSaved: (value) {
                                firstname = value!;
                              },
                              //controller: _namecontroller,
                              decoration: textformdecoration.copyWith(
                                  labelText: 'First Name',
                                  hintText: 'Enter Your First Name')),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 02, 40, 02),
                          child: TextFormField(
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              }),
                              onSaved: (value) {
                                lastname = value!;
                              },
                              decoration: textformdecoration.copyWith(
                                  labelText: 'Last Name',
                                  hintText: 'Enter Your Last Name')),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                          child: TextFormField(
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Phone Number';
                                }
                                return null;
                              }),
                              onSaved: (value) {
                                mobilenumber = value!;
                              },
                              decoration: textformdecoration.copyWith(
                                  labelText: 'Mobile Number',
                                  hintText: 'Enter Your Mobile Number')),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              //color: Colors.blueGrey[100],
                              gradient: LinearGradient(colors: [
                                const Color.fromARGB(255, 15, 113, 162)
                                    .withOpacity(0.2),
                                Colors.blueGrey.withOpacity(0.4),
                              ]),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 111, 158, 173)),
                            ),
                            height: MediaQuery.of(context).size.height * 0.222,
                            width: MediaQuery.of(context).size.width * 0.87,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SelectState(
                                onCountryChanged: (value) {
                                  setState(() {
                                    countryValue = value;
                                  });
                                },
                                onStateChanged: (value) {
                                  setState(() {
                                    stateValue = value;
                                  });
                                },
                                onCityChanged: (value) {
                                  setState(() {
                                    cityValue = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: TextFormField(
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return 'Please enter Address in Detail';
                              }
                              return null;
                            }),
                            onSaved: (value) {
                              faddress = value!;
                            },
                            //controller: _namecontroller,
                            decoration: textformdecoration.copyWith(
                                labelText: 'Address in Detail / Landmark',
                                hintText:
                                    'Flat, House no., Area, Building, Street, Appartment, Sector, Village, Company'),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                    child: Button(
                        buttonlabel: 'Add Address',
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            if (countryValue != 'Choose Country' &&
                                stateValue != 'Choose State' &&
                                cityValue != 'Choose City') {
                              formkey.currentState!.save();
                              CollectionReference addressReference =
                                  FirebaseFirestore.instance
                                      .collection('custumers')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection('address');
                              var addressId = const Uuid().v4();
                              await addressReference.doc(addressId).set({
                                'addressid': addressId,
                                'firstname': firstname,
                                'lastname': lastname,
                                'phone': mobilenumber,
                                'country': countryValue,
                                'state': stateValue,
                                'city': cityValue,
                                'faddress': faddress,
                                'default': true,
                              }).whenComplete(() => Navigator.pop(context));
                            } else {
                              MyMessageBuilder.showSnackBar(
                                  scaffoldKey, 'Fill Set Valid Address');
                            }
                          } else {
                            MyMessageBuilder.showSnackBar(
                                scaffoldKey, 'Fill Fields with Valid Info');
                          }
                        },
                        buttonwidth: 0.7),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
