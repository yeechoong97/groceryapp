class ItemDetails {
  String id;
  String itemName;
  int itemQuantity;
  String itemURL;
  String itemPrice;

  ItemDetails(
      this.id, this.itemName, this.itemQuantity, this.itemURL, this.itemPrice);
}

class OrderTotal {
  int itemQuantity;
  double totalPrice;

  OrderTotal(this.itemQuantity, this.totalPrice);
}

class ItemList {
  String categoryName;
  String itemName;
  String itemURL;
  String price;

  ItemList(this.categoryName, this.itemName, this.itemURL, this.price);
}

class OrderSummary {
  String id;
  String dateTime;
  int itemQuantity;
  double totalPrice;
  String address;
  String contact;

  OrderSummary(this.id, this.dateTime, this.itemQuantity, this.totalPrice,
      this.address, this.contact);
}
