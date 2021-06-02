import 'package:cloud_firestore/cloud_firestore.dart';

class AllTransactionsModel {
  var amount;
  var costPrice;
  var date;
  var moneyReceived;
  var moneySpent;
  var newStock;
  var previousStock;
  var productId;
  var productName;
  var sellingPrice;

  AllTransactionsModel.fromFireBase(DocumentSnapshot documentSnapshot) {
    this.amount = documentSnapshot.get("amount");
    this.costPrice = documentSnapshot.get("cost_price");
    this.date = documentSnapshot.get("date");
    this.moneyReceived = documentSnapshot.get("money_received");
    this.moneySpent = documentSnapshot.get("money_spent");
    this.newStock = documentSnapshot.get("new_stock");
    this.previousStock = documentSnapshot.get("previous_stock");
    this.productId = documentSnapshot.get("product_id");
    this.productName = documentSnapshot.get("product_name");
    this.sellingPrice = documentSnapshot.get("selling_price");
  }
}
