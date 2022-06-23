import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/auth/custumerloginscreen.dart';
import 'package:multi_store_app/auth/custumersignupscreen.dart';
import 'package:multi_store_app/auth/supplierloginscreen.dart';
import 'package:multi_store_app/auth/suppliersignupscreen.dart';
import 'package:multi_store_app/provider/cartprovider.dart';
import 'package:multi_store_app/provider/wishlistprovider.dart';
import 'package:provider/provider.dart';
import 'main_screen/custumerhome.dart';
import 'main_screen/supplierhome.dart';
import 'main_screen/welcomescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProvider(create: (_) => WishList())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: WelcomeScreen(),
      initialRoute: '/welcome_screen',
      routes: {
        '/welcome_screen': ((context) => const WelcomeScreen()),
        '/custumer_home_screen': ((context) => const CustumerHomeScreen()),
        '/supplier_home_screen': ((context) => const SupplierHomeScreen()),
        '/custumer_signup_screen': ((context) => const CustumerRegister()),
        '/custumer_login_screen': ((context) => const CustumerLogin()),
        '/supplier_signup_screen': ((context) => const SupplierRegister()),
        '/supplier_login_screen': ((context) => const SupplierLogin()),
      },
    );
  }
}
