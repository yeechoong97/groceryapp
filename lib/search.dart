import 'package:flutter/material.dart';
import 'class.dart';
import 'itemTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  bool loading = true;
  bool initialSearch = true;
  List<ItemList> _itemList = [];
  final firebase = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  void retrieveItem(String value) async {
    setState(() {
      initialSearch = false;
      loading = true;
    });
    String cleanValue = value.trim().toLowerCase();
    var collectionItem = await firebase.collection('item').get();

    await Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _itemList = [];
        collectionItem.docs.forEach((element) {
          if (element['categoryName']
                  .toString()
                  .toLowerCase()
                  .contains(cleanValue) ||
              element['itemName'].toString().toLowerCase().contains(cleanValue))
            _itemList.add(new ItemList(element['categoryName'],
                element['itemName'], element['itemURL'], element['price']));
        });
        loading = false;
        if (_itemList.length == 0) _showEmpty(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      onSubmitted: (value) => retrieveItem(value),
                      decoration: InputDecoration(
                        hintText: 'Search Item Here',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: initialSearch
                  ? Center()
                  : ListView.builder(
                      itemCount: loading ? 5 : _itemList.length,
                      itemBuilder: (context, index) => loading
                          ? ItemTile(context: context).buildSkeleton(context)
                          : ItemTile(context: context, filteredList: _itemList)
                              .buildItems(context, index),
                    ),
            )
          ],
        ),
      ),
    );
  }

  void _showEmpty(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: const Text("No Result Found.."),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
        ),
      ),
    );
  }
}
