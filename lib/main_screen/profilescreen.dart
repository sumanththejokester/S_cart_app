import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:multi_store_app/main_screen/cartscreen.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';

import '../custumer_profile_components/custumerordersscreen.dart';
import '../custumer_profile_components/custumerwishlistscreen.dart';
import '../widgets/CupertinoDialog.dart';

class ProfileScreen extends StatefulWidget {
  final String? documentId;
  const ProfileScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference custumers =
      FirebaseFirestore.instance.collection('custumers');
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseAuth.instance.currentUser!.isAnonymous
          ? anonymous.doc((widget.documentId)).get()
          : custumers.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String?, dynamic> data =
              snapshot.data!.data() as Map<String?, dynamic>;
          return Scaffold(
            body: Stack(children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.blueGrey,
                  Color.fromARGB(255, 15, 113, 162),
                ])),
              ),
              CustomScrollView(slivers: [
                SliverAppBar(
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Colors.blueGrey[100],
                  expandedHeight: 140,
                  flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                    return FlexibleSpaceBar(
                      title: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: constraints.biggest.height <= 120 ? 1 : 0,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.23),
                          child: const Text(
                            'Account',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      background: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Colors.blueGrey,
                          Color.fromARGB(255, 15, 113, 162),
                        ])),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50, top: 25),
                          child: Row(
                            children: [
                              data['profileimage'] == ''
                                  ? const CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          AssetImage('images/inapp/guest.jpg'),
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          NetworkImage(data['profileimage']),
                                    ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text(
                                  data['name'] == ''
                                      ? 'guest'.toUpperCase()
                                      : data['name'].toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Color.fromARGB(255, 158, 158, 158)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width * 0.85,
                        decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 70,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 137, 164, 178),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      bottomLeft: Radius.circular(25))),
                              child: TextButton(
                                child: SizedBox(
                                  height: 70,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: const Center(
                                    child: Text(
                                      'Cart',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 17),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CartScreen(
                                                back: AppBarBackButton(),
                                              )));
                                },
                              ),
                            ),
                            Container(
                              height: 70,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 52, 137, 179),
                                //borderRadius: BorderRadius.only(
                                //  topLeft: Radius.circular(25),
                                //bottomLeft: Radius.circular(25))
                              ),
                              child: TextButton(
                                child: SizedBox(
                                  height: 70,
                                  width:
                                      MediaQuery.of(context).size.width * 0.28,
                                  child: const Center(
                                    child: Text(
                                      'Orders',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CustumerOrdersScreen()));
                                },
                              ),
                            ),
                            Container(
                              height: 70,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 137, 164, 178),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      bottomRight: Radius.circular(25))),
                              child: TextButton(
                                child: SizedBox(
                                  height: 70,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: const Center(
                                    child: Text(
                                      'Wishlist',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 17),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CustumerWishListScreen()));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 150,
                        child: Image(
                            image: AssetImage('images/inapp/app_logo.png')),
                      ),
                      const ProfileHeaderLabel(
                        headerlabel: 'Account Info',
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 260,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              color: Colors.blueGrey[100],
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text('Email Address'),
                                subtitle: data['email'] == ''
                                    ? const Text('example@email.com')
                                    : Text(data['email']),
                                leading: const Icon(Icons.email),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 1,
                                ),
                              ),
                              ListTile(
                                title: const Text('Mobile Number'),
                                subtitle: data['phone'] == ''
                                    ? const Text('example: +11111')
                                    : Text(data['phone']),
                                leading: const Icon(Icons.phone),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 1,
                                ),
                              ),
                              ListTile(
                                title: const Text('Address'),
                                subtitle: data['address'] == ''
                                    ? const Text('example : India ')
                                    : Text(data['address']),
                                leading: const Icon(Icons.house),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const ProfileHeaderLabel(headerlabel: 'Account Settings'),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 260,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              color: Colors.blueGrey[100],
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: const ListTile(
                                  title: Text('Edit Profile'),
                                  //subtitle: Text(''),
                                  leading: Icon(Icons.edit),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 1,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: const ListTile(
                                  title: Text('Change Password'),
                                  //subtitle: Text(''),
                                  leading: Icon(Icons.lock),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 1,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  MyCupertinoAlertDialog.showMyCupertinoDialog(
                                    context: context,
                                    title: 'Log Out',
                                    content: 'Sure you want to Log Out ?',
                                    tapNo: () {
                                      Navigator.pop(context);
                                    },
                                    tapYes: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pop(context);
                                      Navigator.pushReplacementNamed(
                                          context, '/welcome_screen');
                                    },
                                  );
                                },
                                child: const ListTile(
                                  title: Text('Log Out'),
                                  //subtitle: Text(''),
                                  leading: Icon(Icons.logout),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ]),
          );
        }

        return const Center(
          child: CircularProgressIndicator(
            color: Colors.purple,
          ),
        );
      },
    );
  }
}

class ProfileHeaderLabel extends StatelessWidget {
  final String headerlabel;
  const ProfileHeaderLabel({Key? key, required this.headerlabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 40,
              width: 50,
              child: Divider(
                color: Colors.white,
                thickness: 1,
              ),
            ),
            Text(
              headerlabel,
              style: const TextStyle(color: Colors.white, fontSize: 30),
            ),
            const SizedBox(
              height: 40,
              width: 50,
              child: Divider(
                color: Colors.white,
                thickness: 1,
              ),
            ),
          ],
        ));
  }
}
