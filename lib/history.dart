import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:ecommerce/skeleton_container.dart';
import 'package:flutter/material.dart';
import 'class.dart';
import 'history_details.dart';

class HistoryScreen extends StatefulWidget {
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<HistoryScreen> {
  bool loading = true;
  String userEmail = "";
  final firebase = FirebaseFirestore.instance;
  List<OrderSummary> _orderSummary = [];

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
    fetchData();
  }

  void navigateDetails(OrderSummary value) {
    Navigator.pushNamed(context, HistoryDetails.routeName, arguments: value);
  }

  void fetchData() async {
    var collectionOrder = await firebase
        .collection('order')
        .where('userEmail', isEqualTo: userEmail)
        .get();
    setState(() {
      collectionOrder.docs.forEach((element) {
        Timestamp dateTime = element['timestamp'];
        String formattedDateTime =
            DateTime.fromMicrosecondsSinceEpoch(dateTime.microsecondsSinceEpoch)
                .toString();
        _orderSummary.add(new OrderSummary(
            element.id,
            formattedDateTime,
            element['itemQuantity'],
            element['totalPrice'],
            element['address'],
            element['contact']));
      });
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History"),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: loading ? 5 : _orderSummary.length,
          itemBuilder: (context, index) =>
              loading ? buildSkeleton(context) : buildBody(context, index),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context, int index) {
    return Card(
      child: ListTile(
        title: Text(_orderSummary[index].dateTime),
        subtitle: Text("RM ${_orderSummary[index].totalPrice}"),
        trailing: Icon(Icons.chevron_right),
        onTap: () => navigateDetails(_orderSummary[index]),
      ),
    );
  }

  Widget buildSkeleton(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SkeletonContainer.square(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 20),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SkeletonContainer.square(width: 60, height: 20),
                ),
              ]),
        ],
      ),
    );
  }
}
