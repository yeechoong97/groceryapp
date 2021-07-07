import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'itemTile.dart';
import 'class.dart';

class Item extends StatefulWidget {
  static const routeName = '/category/item';
  final argument;

  Item({this.argument});

  @override
  _ItemState createState() => _ItemState(this.argument);
}

class _ItemState extends State<Item> {
  List<ItemList> _filteredList = [];
  final args;
  bool loading = true;
  final firebase = FirebaseFirestore.instance;
  _ItemState(this.args);

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    var collectionItem = await firebase.collection('item').get();

    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        collectionItem.docs.forEach((doc) {
          if (doc['categoryName'] == args.toString()) {
            _filteredList.add(new ItemList(doc['categoryName'], doc['itemName'],
                doc['itemURL'], doc['price']));
          }
        });
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.argument.toString()),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: loading ? 5 : _filteredList.length,
          itemBuilder: (context, index) => loading
              ? ItemTile(context: context).buildSkeleton(context)
              : ItemTile(context: context, filteredList: _filteredList)
                  .buildItems(context, index),
        ),
      ),
    );
  }
}
