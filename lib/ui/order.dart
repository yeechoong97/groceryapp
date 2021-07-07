import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/components/loading.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class Order extends StatefulWidget {
  static final routeName = '/cart/order';
  final args;
  Order({required this.args});
  _OrderState createState() => _OrderState(this.args);
}

class _OrderState extends State<Order> {
  final args;
  final firebase = FirebaseFirestore.instance;
  String contact = "";
  String address = "";
  String userEmail = "";
  bool loading = false;

  _OrderState(this.args);

  @override
  void initState() {
    super.initState();
    retrieveUserEmail();
  }

  void retrieveUserEmail() async {
    var user = await AuthService().getCurrentUser();
    setState(() {
      userEmail = user.email;
    });
  }

  void saveContact(String value) {
    setState(() {
      contact = value;
    });
  }

  void saveAddress(String value) {
    setState(() {
      address = value;
    });
  }

  void saveOrder(BuildContext context) async {
    setState(() {
      loading = true;
    });
    _showMyDialog(context);

    var collectionCart = await firebase
        .collection('cart')
        .where('userEmail', isEqualTo: userEmail)
        .get();
    Map<String, int> cartItems = new Map();
    collectionCart.docs.forEach((element) {
      cartItems[element['itemName']] = element['itemQuantity'];
      firebase.collection('cart').doc(element.id).delete();
    });

    await firebase.collection('order').add({
      'userEmail': userEmail,
      'totalPrice': args.totalPrice,
      'itemQuantity': args.itemQuantity,
      'itemList': cartItems,
      'address': address,
      'contact': contact,
      'timestamp': Timestamp.now(),
    });

    await Future.delayed(Duration(seconds: 3), () {
      setState(() {
        loading = false;
        Navigator.pop(context);
      });
    });
    _showMyDialog(context);
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) => loading
          ? loadingAnimation()
          : AlertDialog(
              title: const Text('Order Succeed'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('Purchased Successfully'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, "true");
                  },
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Page"),
        actions: <Widget>[
          IconButton(
            onPressed: () => saveOrder(context),
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: bodyOrder(context),
    );
  }

  Widget bodyOrder(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Item Quantity: ",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8.0),
                padding: EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  color: Colors.grey[300],
                ),
                child: Text(
                  args.itemQuantity.toString(),
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16.0),
                child: Text(
                  "Total Price: ",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8.0),
                padding: EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  color: Colors.grey[300],
                ),
                child: Text(
                  "RM ${args.totalPrice.toString()}",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16.0),
                child: Text(
                  "Contact: ",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8.0),
                child: TextField(
                  onChanged: (value) => saveContact(value),
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    hintText: "Enter Contact Here",
                    contentPadding: EdgeInsets.all(12),
                    focusedBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16.0),
                child: Text(
                  "Address: ",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8.0),
                child: TextField(
                  onChanged: (value) => saveAddress(value),
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    hintText: "Enter Address Here",
                    contentPadding: EdgeInsets.all(12),
                    focusedBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
