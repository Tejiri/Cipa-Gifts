import 'package:cloud_firestore/cloud_firestore.dart';

class SalesModel {
  var amount;
  var costPrice;
  var date;
  var moneyReceived;
  var newStock;
  var previousStock;
  var productId;
  var productName;
  var sellingPrice;

  SalesModel.fromFireBase(DocumentSnapshot documentSnapshot) {
    this.amount = documentSnapshot.get("amount");
    this.costPrice = documentSnapshot.get("cost_price");
    this.date = documentSnapshot.get("date");
    this.moneyReceived = documentSnapshot.get("money_received");
    this.newStock = documentSnapshot.get("new_stock");
    this.previousStock = documentSnapshot.get("previous_stock");
    this.productId = documentSnapshot.get("product_id");
    this.productName = documentSnapshot.get("product_name");
    this.sellingPrice = documentSnapshot.get("selling_price");
  }
}
