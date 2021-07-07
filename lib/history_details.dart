import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:flutter/material.dart';
import 'class.dart';
import 'itemTile.dart';

class HistoryDetails extends StatefulWidget {
  static final routeName = "/history/details";
  final argument;

  HistoryDetails({this.argument});

  _HistoryState createState() => _HistoryState(this.argument);
}

class _HistoryState extends State<HistoryDetails> {
  Map<String, dynamic> _itemList = new Map();
  List<ItemList> _purchasedItem = [];
  List<int> _quantity = [];
  bool loading = true;
  OrderSummary orderSummary;
  final firebase = FirebaseFirestore.instance;
  _HistoryState(this.orderSummary);

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var collectionCart =
        await firebase.collection('order').doc(orderSummary.id).get();
    var collectionItem = await firebase.collection('item').get();
    setState(() {
      _itemList = new Map<String, dynamic>.from(collectionCart.get('itemList'));
      collectionItem.docs.forEach((element) {
        for (var index in _itemList.entries) {
          if (index.key == element['itemName']) {
            _purchasedItem.add(new ItemList(element['categoryName'],
                element['itemName'], element['itemURL'], element['price']));
            _quantity.add(index.value);
          }
        }
      });
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            topContainer(),
            Container(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Item List(s) ",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                  itemCount: loading ? 5 : _purchasedItem.length,
                  itemBuilder: (context, index) => loading
                      ? ItemTile(context: context).buildSkeleton(context)
                      : itemListing(context, index)),
            ),
          ],
        ),
      ),
    );
  }

  Widget topContainer() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Date Time: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(orderSummary.dateTime),
                ]),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Item Quantity: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(orderSummary.itemQuantity.toString()),
                ]),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Price: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("RM ${orderSummary.totalPrice.toString()}"),
                ]),
          ),
          Divider(color: Colors.grey[500]),
        ],
      ),
    );
  }

  Widget itemListing(BuildContext context, int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(_purchasedItem[index].itemURL),
        ),
        title: Text(
          "${_purchasedItem[index].itemName} x ${_quantity[index].toString()}",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        subtitle: Text(
          "RM ${_purchasedItem[index].price}/KG",
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        trailing: Text(
          "RM ${(double.parse(_purchasedItem[index].price) * _quantity[index]).toStringAsFixed(2)}",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
