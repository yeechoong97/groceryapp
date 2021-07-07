import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:ecommerce/skeleton_container.dart';
import 'package:flutter/material.dart';

import 'class.dart';

class ItemTile {
  final firebase = FirebaseFirestore.instance;
  final BuildContext context;
  List<ItemList>? filteredList = [];

  ItemTile({required this.context, this.filteredList});

  void addtoCart(ItemList item) async {
    var collectionCart = await firebase.collection('cart').get();
    var user = await AuthService().getCurrentUser();

    if (collectionCart.docs.isEmpty)
      addItemCart(item, user.email);
    else {
      var existingItem = await firebase
          .collection('cart')
          .where('itemName', isEqualTo: item.itemName)
          .where('userEmail', isEqualTo: user.email)
          .get();

      if (existingItem.docs.isEmpty)
        addItemCart(item, user.email);
      else {
        String itemID = existingItem.docs.first.id;
        int itemQuantity = existingItem.docs.first.get('itemQuantity');
        await firebase
            .collection('cart')
            .doc(itemID)
            .update({'itemQuantity': itemQuantity + 1});
      }
    }
    _showToast(context);
  }

  Future addItemCart(ItemList item, String email) async {
    await firebase.collection('cart').add({
      'userEmail': email,
      'itemName': item.itemName,
      'itemQuantity': 1,
      'itemPrice': item.price,
      'itemURL': item.itemURL
    });
  }

  Widget buildItems(BuildContext context, int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(filteredList![index].itemURL),
        ),
        title: Text(
          filteredList![index].itemName,
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        subtitle: Text(
          "RM ${filteredList![index].price}/KG",
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        trailing: TextButton(
          onPressed: () => addtoCart(filteredList![index]),
          child: Text(
            "Add",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
        ),
      ),
    );
  }

  Widget buildSkeleton(BuildContext context) {
    return Row(children: <Widget>[
      Padding(
        padding: EdgeInsets.all(8.0),
        child: SkeletonContainer.square(width: 60, height: 60),
      ),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Padding(
          padding: EdgeInsets.all(4.0),
          child: SkeletonContainer.square(
              width: MediaQuery.of(context).size.width * 0.5, height: 15),
        ),
        Padding(
          padding: EdgeInsets.all(4.0),
          child: SkeletonContainer.square(width: 60, height: 15),
        ),
      ]),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.0, top: 4.0),
            child: SkeletonContainer.square(width: 65, height: 30),
          ),
        ],
      )
    ]);
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: const Text("Cart Updated Successfully"),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
        ),
      ),
    );
  }
}
