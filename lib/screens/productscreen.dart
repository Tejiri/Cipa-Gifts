import 'package:cipa_gifts/firebase/firebasemethods.dart';
import 'package:cipa_gifts/helpers/random.dart';
import 'package:cipa_gifts/models/productmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sweetalert/sweetalert.dart';

class ProductScreen extends StatefulWidget {
  int id;

  ProductScreen(this.id);

  @override
  _ProductScreenState createState() => _ProductScreenState(this.id);
}

class _ProductScreenState extends State<ProductScreen> {
  int id;
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productStockController = TextEditingController();
  TextEditingController updateStockController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  var sellingPrice;
  var updateStockNumber = 0;
  var modalBoolean = false;
  var appbarText;

  _ProductScreenState(this.id);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }

  getName() async {
    await getProductName(id).then((value) {
      appbarText = "Edit $value";
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: Text("$appbarText"),
        backgroundColor: HexColor("#086ad8"),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            padding: EdgeInsets.only(right: 10),
            color: Colors.white,
            onPressed: () {
              displayBottomSheetGraph();
            },
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: modalBoolean,
        child: ListView(
          children: [
            StreamBuilder(
                stream: firebaseFirestore
                    .collection("products")
                    .doc(id.toString())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    final product = ProductModel.fromFireBase(snapshot.data);
                    // appbarText = product.productName.toString();
                    //DocumentSnapshot data = snapshot.data;
                    final productImage = product.imageUrl;

                    // print();
                    //
                    //

                    productNameController.text = product.productName;
                    productPriceController.text = product.costPrice.toString();
                    productStockController.text =
                        product.productQuantity.toString();

                    if (sellingPrice == null) {
                      sellingPrice = product.costPrice;
                      sellingPriceController.text = sellingPrice.toString();
                    }

                    return Column(
                      children: [
                        Container(
                            //margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                            width: double.infinity,
                            height: 300,
                            color: Colors.black.withOpacity(0.8),
                            child: Image.network(
                              productImage,
                              fit: BoxFit.fill,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                );
                              },
                            )),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          width: double.infinity,
                          //color: Colors.blueGrey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: EdgeInsets.only(top: 20)),
                              Text(
                                "Product ID - ${product.id}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              Padding(padding: EdgeInsets.only(top: 15)),
                              showTextField(
                                  productNameController,
                                  TextInputType.text,
                                  "Product name",
                                  "Product name"),
                              Padding(padding: EdgeInsets.only(top: 20)),
                              showTextField(
                                  productPriceController,
                                  TextInputType.number,
                                  "Product price",
                                  "Product price"),
                              Padding(padding: EdgeInsets.only(top: 20)),
                              Container(
                                child: Wrap(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "Stock Count - " +
                                              formatNumber(product
                                                  .productQuantity
                                                  .toString()),
                                          style: TextStyle(fontSize: 20),
                                        )),
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: ButtonTheme(
                                        child: RaisedButton(
                                          color: HexColor("#086ad8"),
                                          child: Text("Manage Stock"),
                                          onPressed: () {
                                            updateStockController.text =
                                                updateStockNumber.toString();
                                            // updateStock(
                                            //     product.id.toString(),
                                            //     productNameController.text,
                                            //     productPriceController.text,
                                            //     updateStockNumber,
                                            //     //newImageUrl,
                                            //     'stock update');
                                            updateStockDialog(product);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 15)),
                              updateStockNumber < 0
                                  ? Text(
                                      "Deduct ${formatNumber(updateStockNumber.toString())} from stock. Stock count left will be ${formatNumber((product.productQuantity + updateStockNumber).toString())}. Product sold at ${"₦" + formatNumber(sellingPrice.toString())}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    )
                                  : Container(),
                              updateStockNumber > 0
                                  ? Text(
                                      "Add ${formatNumber(updateStockNumber.toString())} to stock. Stock count left will be ${formatNumber((product.productQuantity + updateStockNumber).toString()).trim()} ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Container(),
                              Padding(padding: EdgeInsets.only(top: 15)),
                              Text(
                                "Last modified - ${DateFormat.yMMMMEEEEd().add_jms().format(product.datePublished.toDate())}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Padding(padding: EdgeInsets.only(top: 15)),
                              ButtonTheme(
                                  minWidth: double.infinity,
                                  child: RaisedButton(
                                    color: HexColor("#086ad8"),
                                    onPressed: () {
                                      setState(() {
                                        modalBoolean = true;
                                      });
                                      checkForInternet().then((value) => {
                                            if (value == true)
                                              {
                                                updateProduct(
                                                        product.imageUrl,
                                                        product.id,
                                                        productNameController
                                                            .text,
                                                        int.parse(
                                                            productPriceController
                                                                .text),
                                                        int.parse(
                                                            sellingPriceController
                                                                .text),
                                                        updateStockNumber)
                                                    .then((value) {
                                                  setState(() {
                                                    modalBoolean = false;
                                                  });
                                                  updateStockNumber = 0;
                                                  if (value) {
                                                    SweetAlert.show(context,
                                                        title: "Success",
                                                        subtitle:
                                                            "Product updated successfully",
                                                        style: SweetAlertStyle
                                                            .success);
                                                  } else if (value == false) {
                                                    SweetAlert.show(context,
                                                        title: "Failed",
                                                        subtitle:
                                                            "Product not updated, something went wrong",
                                                        style: SweetAlertStyle
                                                            .error);
                                                  }
                                                })
                                              }
                                            else
                                              {
                                                setState(() {
                                                  modalBoolean = false;
                                                }),
                                                SweetAlert.show(context,
                                                    title: "No internet",
                                                    subtitle:
                                                        "Internet connection required to upload product",
                                                    style:
                                                        SweetAlertStyle.error)
                                              }
                                          });
                                    },
                                    child: Text("Update Product details"),
                                  ))
                            ],
                          ),
                        )
                      ],
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  showTextField(TextEditingController controller, TextInputType textInputType,
      String hintText, String labelText) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        keyboardType: textInputType,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'WorkSans',
          ),
          labelText: labelText,
          labelStyle: TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        onChanged: (value) {},
      ),
    );
  }

  updateStockDialog(ProductModel product) {
    setState(() {
      sellingPrice = product.costPrice;
      sellingPriceController.text = sellingPrice.toString();
    });
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return AlertDialog(
              title: Text(
                "Manage Stock",
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Wrap(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  updateStockNumber--;
                                  updateStockController.text =
                                      updateStockNumber.toString();
                                });
                              },
                            ),
                          ),
                        ),
                        IntrinsicWidth(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(),
                            controller: updateStockController,
                            onChanged: (value) {
                              setState(() {
                                updateStockNumber = int.parse(value);
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  updateStockNumber++;
                                  updateStockController.text =
                                      updateStockNumber.toString();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (updateStockNumber < 0) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Set Selling Price"),
                                  content: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: sellingPriceController,
                                    onChanged: (value) {
                                      setState(() {
                                        sellingPrice = value;
                                      });
                                    },
                                  ),
                                  actions: [
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Accept"),
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          updateStockNumber = 0;
                                          sellingPrice = product.costPrice;
                                        });
                                      },
                                      child: Text("Cancel"),
                                    ),
                                  ],
                                );
                              });
                        } else {}
                      },
                      child: Text("Accept Changes"),
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  displayBottomSheetGraph() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StreamBuilder(
            stream: firebaseFirestore
                .collection('products')
                .doc(id.toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                DocumentSnapshot data = snapshot.data;
                ProductModel productModel = ProductModel.fromFireBase(data);
                return Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 60)),
                    Text(
                      "Product Information",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                        "Pieces Bought:  ${formatNumber(productModel.piecesPurchased.toString())}",
                        style: TextStyle(fontSize: 18)),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Text(
                        "Pieces Sold: ${formatNumber(productModel.piecesSold.toString())}",
                        style: TextStyle(fontSize: 18)),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Text(
                        "Stock left: ${formatNumber(productModel.productQuantity.toString())}",
                        style: TextStyle(fontSize: 18)),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    // Text("Low stock items: " + lowStockItems.toString(),
                    //     style: TextStyle(color: Colors.red, fontSize: 18)),
                    // Padding(padding: EdgeInsets.only(top: 5)),
                    Text(
                        "Total income: ₦${formatNumber(productModel.totalMoneyReceived.toString())}",
                        style: TextStyle(color: Colors.green, fontSize: 18)),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Text(
                        "Total Expenditure: ₦${formatNumber(productModel.totalMoneySpent.toString())}",
                        style: TextStyle(color: Colors.red, fontSize: 18)),
                  ],
                );
              }
            },
          );
        });
  }
}
