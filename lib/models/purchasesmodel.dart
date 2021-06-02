import 'package:cloud_firestore/cloud_firestore.dart';

class PurchasesModel {
  var amount;
  var costPrice;
  var date;
  var moneySpent;
  var newStock;
  var previousStock;
  var productId;
  var productName;

  PurchasesModel.fromFireBase(DocumentSnapshot documentSnapshot) {
    this.amount = documentSnapshot.get("amount");
    this.costPrice = documentSnapshot.get("cost_price");
    this.date = documentSnapshot.get("date");
    this.moneySpent = documentSnapshot.get("money_spent");
    this.newStock = documentSnapshot.get("new_stock");
    this.previousStock = documentSnapshot.get("previous_stock");
    this.productId = documentSnapshot.get("product_id");
    this.productName = documentSnapshot.get("product_name");
  }
}
