import 'package:flutter/material.dart';
import 'item.dart';
import '../class.dart';

class Category extends StatelessWidget {
  List<CategoryList> _categories = [
    new CategoryList(
        "https://image.flaticon.com/icons/png/512/1261/1261126.png", "Grocery"),
    new CategoryList(
        "https://image.flaticon.com/icons/png/512/2331/2331841.png",
        "Electrical Appliance"),
    new CategoryList(
        "https://image.flaticon.com/icons/png/512/2809/2809814.png", "Pet")
  ];

  @override
  Widget build(BuildContext context) {
    void _navigateToItem(String categoryName) {
      Navigator.pushNamed(context, Item.routeName, arguments: categoryName);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Category"),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: _categories == null ? 0 : _categories.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(_categories[index].imageURL),
                  ),
                  title: Text(_categories[index].categoryName),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => _navigateToItem(_categories[index].categoryName),
                ),
              );
            }),
      ),
    );
  }
}
