import 'package:cipa_gifts/helpers/imagehelpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore firebaseFirestore;
FirebaseStorage firebaseStorage;
FirebaseAuth auth;

initializeApp() async {
  try {
    await Firebase.initializeApp().then((value) {
      firebaseFirestore = FirebaseFirestore.instance;
      firebaseStorage = FirebaseStorage.instance;
      auth = FirebaseAuth.instance;
    });
  } catch (e) {
    print(e);
  }
}

Future signUserIn(email2, password2) async {
  var state = false;
  print(email2);
  print(password2);
  try {
    await auth
        .signInWithEmailAndPassword(email: email2, password: password2)
        .then((value) {
      state = true;
    });
    return state;
  } catch (e) {
    return e.message;
  }
}

Future reauthenticate(email,password) async {
  UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
  //auth.currentUser.reauthenticateWithCredential(userCredential)
}

Future<bool> addProduct(productName, costPrice, stockQuantity, image) async {
  var finalBoolean = false;
  DateTime dateNow = new DateTime.now();
  var productId;
  try {
    await firebaseFirestore
        .collection('products')
        .orderBy('id')
        .get()
        .then((collection) async {
      if (collection.size == 0) {
        finalBoolean = await addProduct2(collection.size, productName,
            costPrice, stockQuantity, image, dateNow);
      } else if (collection.size > 0) {
        QueryDocumentSnapshot queryDocumentSnapshot = collection.docs.last;
        String lastId = queryDocumentSnapshot.id;
        productId = int.parse(lastId) + 1;

        finalBoolean = await addProduct2(
            productId, productName, costPrice, stockQuantity, image, dateNow);
      }
    });
    return finalBoolean;
  } catch (e) {
    return finalBoolean;
  }
}

Future<bool> addProduct2(
    productId, productName, costPrice, stockQuantity, image, dateNow) async {
  var result = false;
  try {
    await compressImage(image).then((file) async {
      //var imageUrl;
      await firebaseStorage
          .ref()
          .child("images/" + productId.toString())
          .putFile(file)
          .then((value) async {
        //Reference ref = FirebaseStorage.instance.ref().child(productName);
        await value.ref.getDownloadURL().then((imageUrl) async {
          await firebaseFirestore
              .collection("products")
              .doc(productId.toString())
              .set({
            "id": productId,
            "product_name": productName,
            "cost_price": costPrice,
            "stock_quantity": stockQuantity,
            "date_published": dateNow,
            "image_url": imageUrl,
            'pieces_purchased': stockQuantity,
            'pieces_sold': 0,
            'total_money_spent': costPrice * stockQuantity,
            'total_money_received': 0
          }).onError((error, stackTrace) {
            result = false;
          }).then((value) async {
            await firebaseFirestore
                .collection("purchases")
                .get()
                .then((value) async => await firebaseFirestore
                        .collection("purchases")
                        .doc(value.docs.length.toString())
                        .set({
                      'product_id': productId,
                      'product_name': productName,
                      'cost_price': costPrice,
                      'previous_stock': 0,
                      'new_stock': stockQuantity,
                      'amount': stockQuantity,
                      'date': dateNow,
                      'money_spent': costPrice * stockQuantity,
                    }))
                .then((value) async {
              await firebaseFirestore
                  .collection("all_transactions")
                  .get()
                  .then((value) => firebaseFirestore
                          .collection("all_transactions")
                          .doc(value.docs.length.toString())
                          .set({
                        'product_id': productId,
                        'product_name': productName,
                        'cost_price': costPrice,
                        'selling_price': null,
                        'previous_stock': 0,
                        'new_stock': stockQuantity,
                        'amount': stockQuantity,
                        'date': dateNow,
                        'money_spent': costPrice * stockQuantity,
                        'money_received': null,
                      }))
                  .then((value) {
                result = true;
              });
            });
          });
        });
      });
    });

    return result;
  } catch (e) {
    return result;
  }
}

Future<bool> updateProduct(imageUrl, productId, productName, costPrice,
    sellingPrice, stockQuantity2) async {
  DateTime date = new DateTime.now();
  int oldStock;
  int newStock;
  int totalPiecesPurchased;
  int totalPiecesSold;
  int totalMoneyReceived;
  int totalMoneySpent;
  bool result = false;
  int stockQuantity;
  try {
    var list = stockQuantity2.toString().split('-');
    stockQuantity = int.parse(list[1]);
  } catch (e) {
    stockQuantity = stockQuantity2;
  }
  try {
    await firebaseFirestore
        .collection("products")
        .doc(productId.toString())
        .get()
        .then((value) async {
      oldStock = value.get('stock_quantity');
      newStock = oldStock + stockQuantity2;
      if (stockQuantity2 > 0) {
        totalPiecesPurchased = stockQuantity2 + value.get('pieces_purchased');
        totalPiecesSold = value.get('pieces_sold');
        totalMoneySpent =
            value.get('total_money_spent') + (stockQuantity * costPrice);
        totalMoneyReceived = value.get('total_money_received');
      } else if (stockQuantity2 < 0) {
        totalPiecesSold = stockQuantity + value.get('pieces_sold');
        totalPiecesPurchased = value.get('pieces_purchased');
        totalMoneySpent = value.get('total_money_spent');
        totalMoneyReceived =
            (stockQuantity * sellingPrice) + value.get('total_money_received');
      } else {
        totalPiecesSold = stockQuantity + value.get('pieces_sold');
        totalPiecesPurchased = value.get('pieces_purchased');
        totalMoneySpent = value.get('total_money_spent');
        totalMoneyReceived = value.get('total_money_received');
      }

      await firebaseFirestore
          .collection("products")
          .doc(productId.toString())
          .update({
        'date_published': date,
        'image_url': imageUrl,
        'cost_price': costPrice,
        'product_name': productName,
        'stock_quantity': newStock,
        'pieces_purchased': totalPiecesPurchased,
        'pieces_sold': totalPiecesSold,
        'total_money_received': totalMoneyReceived,
        'total_money_spent': totalMoneySpent
      }).then((value) async {
        if (stockQuantity2 > 0) {
          await firebaseFirestore
              .collection("purchases")
              .get()
              .then((value) => firebaseFirestore
                      .collection("purchases")
                      .doc(value.docs.length.toString())
                      .set({
                    'product_id': productId,
                    'product_name': productName,
                    'cost_price': costPrice,
                    'previous_stock': oldStock,
                    'new_stock': newStock,
                    'amount': stockQuantity,
                    'date': date,
                    'money_spent': costPrice * stockQuantity
                  }))
              .then((value) async {
            await firebaseFirestore
                .collection("all_transactions")
                .get()
                .then((value) => firebaseFirestore
                        .collection("all_transactions")
                        .doc(value.docs.length.toString())
                        .set({
                      'product_id': productId,
                      'product_name': productName,
                      'cost_price': costPrice,
                      'selling_price': null,
                      'previous_stock': oldStock,
                      'new_stock': newStock,
                      'amount': stockQuantity,
                      'date': date,
                      'money_spent': costPrice * stockQuantity,
                      'money_received': null,
                    }))
                .then((value) {
              result = true;
            });
          });
        } else if (stockQuantity2 < 0) {
          await firebaseFirestore
              .collection("sales")
              .get()
              .then((value) => firebaseFirestore
                      .collection("sales")
                      .doc(value.docs.length.toString())
                      .set({
                    'product_id': productId,
                    'product_name': productName,
                    'cost_price': costPrice,
                    'selling_price': sellingPrice,
                    'previous_stock': oldStock,
                    'new_stock': newStock,
                    'amount': stockQuantity,
                    'date': date,
                    'money_received': sellingPrice * stockQuantity
                  }))
              .then((value) async {
            await firebaseFirestore
                .collection("all_transactions")
                .get()
                .then((value) => firebaseFirestore
                        .collection("all_transactions")
                        .doc(value.docs.length.toString())
                        .set({
                      'product_id': productId,
                      'product_name': productName,
                      'cost_price': costPrice,
                      'selling_price': sellingPrice,
                      'previous_stock': oldStock,
                      'new_stock': newStock,
                      'amount': stockQuantity,
                      'date': date,
                      'money_received': sellingPrice * stockQuantity,
                      'money_spent': null
                    }))
                .then((value) {
              result = true;
            });
          });
        } else {
          result = true;
        }
      });
    });
    return result;
  } catch (e) {
    print(e);
    return result;
  }
}

Future<bool> checkIfProductExists(productName) async {
  bool exists = false;
  try {
    await firebaseFirestore.collection("products").get().then((value) {
      for (var item in value.docs) {
        if (productName == item.get('product_name')) {
          exists = true;
        }
      }
    });

    return exists;
  } catch (e) {
    return exists;
  }
}

Future<bool> checkIfProductExists2(id) async {
  bool exists = false;
  try {
    await firebaseFirestore.collection("products").doc(id).get().then((value) {
      if (value.exists == true) {
        exists = true;
      } else {
        exists = false;
      }
    });
    return exists;
  } catch (e) {
    return exists;
  }
}

Future<String> getProductName(id) async {
  String productName;

  try {
    await firebaseFirestore
        .collection("products")
        .doc(id.toString())
        .get()
        .then((value) {
      productName = value.get('product_name');
    });
    return productName;
  } catch (e) {
    //print(productName);
    return productName;
  }
}

Future<DocumentSnapshot> getDocReference(id) async {
  DocumentSnapshot snap;
  try {
    await firebaseFirestore.collection("products").doc(id).get().then((value) {
      snap = value;
    });
    return snap;
  } catch (e) {
    return null;
  }
}
