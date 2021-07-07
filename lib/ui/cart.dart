import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/components/itemTile.dart';
import 'package:ecommerce/ui/order.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:flutter/material.dart';
import '../class.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<CartScreen> {
  int itemQuantity = 0;
  double totalPrice = 0.0;
  List<ItemDetails> _cartList = [];
  bool result = false;
  bool loading = true;
  String userEmail = "";

  final firebase = FirebaseFirestore.instance;

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
    fetchCart();
  }

  void navigateToOrder() async {
    var results = await Navigator.pushNamed(context, Order.routeName,
        arguments: OrderTotal(itemQuantity, totalPrice));
    if (results.toString() == "true") resetCart();
  }

  void resetCart() {
    setState(() {
      _cartList = [];
      itemQuantity = 0;
      totalPrice = 0.00;
    });
  }

  void updateCart(String id, int quantity, bool action) async {
    if (action) {
      await firebase
          .collection('cart')
          .doc(id)
          .update({'itemQuantity': quantity + 1});
    } else {
      if (quantity - 1 == 0)
        await firebase.collection('cart').doc(id).delete();
      else
        await firebase
            .collection('cart')
            .doc(id)
            .update({'itemQuantity': quantity - 1});
    }
    fetchCart();
  }

  Future fetchCart() async {
    resetCart();
    var cartCollection = await firebase
        .collection('cart')
        .where('userEmail', isEqualTo: userEmail)
        .get();
    if (cartCollection.docs.isNotEmpty) {
      setState(() {
        cartCollection.docs.forEach((doc) {
          _cartList.add(new ItemDetails(doc.id, doc['itemName'],
              doc['itemQuantity'], doc['itemURL'], doc['itemPrice']));
          int currentItem = doc['itemQuantity'];
          itemQuantity += currentItem;
          totalPrice += double.parse(doc['itemPrice']) * currentItem;
        });
        totalPrice = double.parse(totalPrice.toStringAsFixed(2));
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart"), actions: <Widget>[
        TextButton(
          onPressed: navigateToOrder,
          child: Text(
            "Checkout",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ]),
      body: topBar(),
    );
  }

  Widget topBar() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Item Quantity",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      itemQuantity.toString(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Total Price",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "RM ${totalPrice.toString()}",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Divider(
            color: Colors.grey[500],
          ),
          Expanded(
            child: cartBody(),
          )
        ],
      ),
    );
  }

  Widget cartBody() {
    return Container(
      child: ListView.builder(
        itemCount: loading ? 5 : _cartList.length,
        itemBuilder: (context, index) => loading
            ? ItemTile(context: context).buildSkeleton(context)
            : cartContent(index),
      ),
    );
  }

  Widget cartContent(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(_cartList[index].itemURL),
        ),
        title: Text(_cartList[index].itemName),
        subtitle: Text(
          "RM ${_cartList[index].itemPrice}",
          style: TextStyle(color: Colors.red),
        ),
        trailing: SizedBox(
          child:
              customizeCart(_cartList[index].id, _cartList[index].itemQuantity),
          width: 110,
          height: 50,
        ),
      ),
    );
  }

  Widget customizeCart(String id, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
            child: Icon(
              Icons.remove,
              color: Colors.white,
              size: 8.0,
            ),
            onPressed: () => updateCart(id, quantity, false),
            style: TextButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: Colors.blue,
              minimumSize: Size(3.0, 3.0),
            )),
        Text(quantity.toString()),
        TextButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 8.0,
            ),
            onPressed: () => updateCart(id, quantity, true),
            style: TextButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: Colors.blue,
              minimumSize: Size(3.0, 3.0),
            )),
      ],
    );
  }
}
