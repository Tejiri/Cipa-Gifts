import 'package:cipa_gifts/firebase/firebasemethods.dart';
import 'package:cipa_gifts/helpers/random.dart';
import 'package:cipa_gifts/models/productmodel.dart';
import 'package:cipa_gifts/screens/productscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SearchProductPage extends StatefulWidget {
  @override
  _SearchProductPageState createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  bool isChecked = false;
  Icon cusIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget cusSearchBar = Text(
    "Search for product",
    style: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  );
  String userSearch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Scaffold(
        backgroundColor: Colors.grey[400],
        appBar: AppBar(
          backgroundColor: HexColor('#086ad8'),
          //toolbarHeight: 80,
          //leading: Image.asset("assets/images/xitalogo-removebg.png"),
          centerTitle: true,
          title: cusSearchBar,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          //backgroundColor: Colors.black,
          actions: <Widget>[
            IconButton(
                icon: cusIcon,
                color: Colors.white,
                onPressed: () {
                  if (this.mounted) {
                    userSearch = "";
                    setState(() {
                      if (this.cusIcon.icon == Icons.search) {
                        //searchlist = [];
                        this.cusIcon = Icon(
                          Icons.cancel,
                          color: Colors.white,
                        );
                        this.cusSearchBar = TextField(
                          onChanged: (value) async {
                            userSearch = value;
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: "Enter search here",
                              border: InputBorder.none),
                          textInputAction: TextInputAction.go,
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        );
                      } else {
                        userSearch = null;
                        this.cusIcon = Icon(
                          Icons.search,
                          color: Colors.white,
                        );
                        this.cusSearchBar = Text(
                          "Search for product",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        );
                      }
                    });
                  }
                })
          ],
        ),
        body: Stack(
          children: [
            Container(
                height: double.infinity,
                width: double.infinity,
                child: Image.asset(
                  "assets/images/xitalogo-removebg.png",
                  fit: BoxFit.cover,
                )),
            ListView(
              children: [
                Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Show low Stock Items",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Checkbox(
                      checkColor: Colors.white,
                      value: isChecked,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      onChanged: (bool value) {
                        print(value);
                        setState(() {
                          isChecked = value;
                        });
                      },
                    ),
                  ],
                ),
                Divider(thickness: 2,color: Colors.black,),
                StreamBuilder<QuerySnapshot>(
                  stream: firebaseFirestore
                      .collection("products")
                      .orderBy("id")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<Widget> productWidgets = [];
                      final value = snapshot.data.docs;

                      //print(value);
                      for (var item in value) {
                        //print(item.get("product_name"));
                        ProductModel productModel =
                            ProductModel.fromFireBase(item);
                        final productName = productModel.productName;
                        final productPrice = productModel.costPrice;
                        final productStock = productModel.productQuantity;
                        final productImage = productModel.imageUrl;
                        //print(productImage);
                        final datePublished = productModel.datePublished;
                        final id = productModel.id;
                        // print(productName);
                        // print(userSearch.toString());
                        //final timePublished = productModel.timePublished;

                        if (isChecked == true) {
                          if (productModel.productQuantity < 10) {
                            print(true);
                            if (productName.toString().toLowerCase().contains(
                                userSearch.toString().toLowerCase())) {
                              productWidgets.add(addProductWidget(
                                  productName,
                                  productStock,
                                  DateFormat.yMMMMEEEEd()
                                      .add_jms()
                                      .format(datePublished.toDate()),
                                  productPrice,
                                  productImage,
                                  id));
                            } else if (userSearch == null) {
                              productWidgets.add(addProductWidget(
                                productName,
                                productStock,
                                DateFormat.yMMMMEEEEd()
                                    .add_jms()
                                    .format(datePublished.toDate()),
                                productPrice,
                                productImage,
                                id,
                              ));

                              //print(item.id);
                            }
                          } else {
                            productWidgets.add(Text(
                              "No low stock products found",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ));
                          }
                        } else {
                          if (productName
                              .toString()
                              .toLowerCase()
                              .contains(userSearch.toString().toLowerCase())) {
                            productWidgets.add(addProductWidget(
                                productName,
                                productStock,
                                DateFormat.yMMMMEEEEd()
                                    .add_jms()
                                    .format(datePublished.toDate()),
                                productPrice,
                                productImage,
                                id));
                          } else if (userSearch == null) {
                            productWidgets.add(addProductWidget(
                              productName,
                              productStock,
                              DateFormat.yMMMMEEEEd()
                                  .add_jms()
                                  .format(datePublished.toDate()),
                              productPrice,
                              productImage,
                              id,
                            ));

                            //print(item.id);
                          }
                        }
                      }

                      return Column(
                        children: productWidgets,
                      );
                    }

                    // for (var item in value) {
                    //   print(item.id);
                    // }
                  },
                ),
              ],
            )
          ],
        ));
  }

  addProductWidget(
      productName, productStock, lastUpdated, productPrice, productImage, id) {
    return Column(
      children: <Widget>[
        // Container(
        //     margin: EdgeInsets.only(top: 50, left: 20, right: 20),
        //     width: double.infinity,
        //     height: 250,
        //     color: Colors.white.withOpacity(0.8),
        //     child: Image.network(
        //       productImage,
        //       fit: BoxFit.fill,
        //       loadingBuilder: (context, child, loadingProgress) {
        //         if (loadingProgress == null) return child;
        //         return Center(
        //           child: CircularProgressIndicator(
        //             value: loadingProgress.expectedTotalBytes != null
        //                 ? loadingProgress.cumulativeBytesLoaded /
        //                     loadingProgress.expectedTotalBytes
        //                 : null,
        //           ),
        //         );
        //       },
        //     )),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          padding: EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0)),
            color: Colors.white.withOpacity(0.9),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 5)),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  width: double.infinity,
                  child: Text(
                    "Product ID - " + id.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'WorkSans',
                    ),
                  )),
              Padding(padding: EdgeInsets.only(top: 5)),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  width: double.infinity,
                  child: Text(
                    "Product Name - " + productName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'WorkSans',
                    ),
                  )),
              Padding(padding: EdgeInsets.only(top: 5)),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  width: double.infinity,
                  child: Text(
                    "Stock quantity - " + formatNumber(productStock.toString()),
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontFamily: 'WorkSans',
                        fontWeight: FontWeight.bold),
                  )),
              Padding(padding: EdgeInsets.only(top: 5)),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                width: double.infinity,
                child: Text(
                  "Price - ₦" + formatNumber(productPrice.toString()),
                  style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  width: double.infinity,
                  child: Text(
                    "Last updated - " + lastUpdated.toString(),
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                        fontFamily: 'WorkSans',
                        fontWeight: FontWeight.bold),
                  )),
              Padding(padding: EdgeInsets.only(top: 10)),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: RaisedButton(
                          color: Colors.blue[600],
                          child: Row(
                            children: <Widget>[
                              Text(
                                "QR Code",
                                style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.black,
                              )
                            ],
                          ),
                          onPressed: () {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("QR Code"),
                                    content: Container(
                                      height: 300,
                                      width: 300,
                                      child: QrImage(
                                        data: id.toString(),
                                        version: QrVersions.auto,
                                        size: 200.0,
                                      ),
                                    ),
                                  );
                                });
                          }),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: RaisedButton(
                          color: Colors.blue[600],
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Manage stock",
                                style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.black,
                              )
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductScreen(id)));
                          }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
