import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/ui/history_details.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../authenticate/authenticate.dart';
import '../authenticate/register.dart';
import 'order.dart';
import 'search.dart';
import 'cart.dart';
import 'category.dart';
import 'history.dart';
import 'home.dart';
import 'item.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/search': (context) => SearchScreen(),
        '/history': (context) => HistoryScreen(),
        '/cart': (context) => CartScreen(),
        '/category': (context) => Category(),
        '/category/item': (context) =>
            Item(argument: ModalRoute.of(context)!.settings.arguments),
        '/cart/order': (context) =>
            Order(args: ModalRoute.of(context)!.settings.arguments),
        '/history/details': (context) => HistoryDetails(
            argument: ModalRoute.of(context)!.settings.arguments),
        '/register': (context) => Register(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: checkAuthentication(),
    );
  }

  Widget checkAuthentication() {
    return StreamBuilder(
        stream: AuthService().user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            dynamic user = snapshot.data;
            if (user == null || user.emailVerified == false) {
              return Authenticate();
            }
            return MyHomePage();
          } else {
            return Center();
          }
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String userEmail = "";
  int item = 0;
  List<Widget> _allPages = [
    HomeScreen(),
    SearchScreen(),
    HistoryScreen(),
    CartScreen(),
  ];

  var firebase = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    retrieveUserEmail();
  }

  Future retrieveUserEmail() async {
    var user = await AuthService().getCurrentUser();
    setState(() {
      userEmail = user.email;
    });
    fetchCartItem();
  }

  Future fetchCartItem() async {
    var collection = await firebase
        .collection('cart')
        .where('userEmail', isEqualTo: userEmail)
        .get();
    if (collection.docs.isNotEmpty) {
      setState(() {
        collection.docs.forEach((element) {
          int quantity = element['itemQuantity'];
          item += quantity;
        });
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget cartNavItem() {
    return Stack(children: <Widget>[
      new Icon(Icons.shopping_bag),
      new Positioned(
        right: 0,
        child: new Container(
          padding: EdgeInsets.all(1),
          decoration: new BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(6),
          ),
          constraints: BoxConstraints(
            minWidth: 12,
            minHeight: 12,
          ),
          child: new Text(
            item.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      )
    ]);
  }

  Widget cartZeroItem() {
    return Icon(Icons.shopping_bag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _allPages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: item == 0 ? cartZeroItem() : cartNavItem(),
            label: 'Cart',
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12.0,
        showUnselectedLabels: true,
        unselectedLabelStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
