import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  var datePublished;
  var id;
  var imageUrl;
  var piecesPurchased;
  var piecesSold;
  var costPrice;
  var productName;
  var productQuantity;
  var totalMoneyReceived;
  var totalMoneySpent;

  ProductModel.fromFireBase(DocumentSnapshot documentSnapshot) {
    this.costPrice = documentSnapshot.get("cost_price");
    this.datePublished = documentSnapshot.get("date_published");
    this.id = documentSnapshot.get("id");
    this.imageUrl = documentSnapshot.get("image_url");
    this.piecesPurchased = documentSnapshot.get("pieces_purchased");
    this.piecesSold = documentSnapshot.get("pieces_sold");
    this.productName = documentSnapshot.get("product_name");
    this.productQuantity = documentSnapshot.get("stock_quantity");
    this.totalMoneyReceived = documentSnapshot.get("total_money_received");
    this.totalMoneySpent = documentSnapshot.get("total_money_spent");
  }
}
