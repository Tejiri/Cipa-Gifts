import 'package:cipa_gifts/firebase/firebasemethods.dart';
import 'package:cipa_gifts/helpers/random.dart';
import 'package:cipa_gifts/models/alltransactionsmodel.dart';
import 'package:cipa_gifts/models/purchasesmodel.dart';
import 'package:cipa_gifts/models/salesmodel.dart';
import 'package:cipa_gifts/screens/mobilepdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class TransactionsPage extends StatefulWidget {
  int transactionsToDisplay;
  TransactionsPage(this.transactionsToDisplay);
  @override
  _TransactionsPageState createState() =>
      _TransactionsPageState(this.transactionsToDisplay);
}

class _TransactionsPageState extends State<TransactionsPage> {
  var productIdList = [];
  var productNameList = [];
  var costPriceList = [];
  var sellingPriceList = [];
  var quantityList = [];
  var moneyReceivedList = [];
  var moneySpentList = [];
  var dateList = [];

  int transactionsToDisplay = 0;
  int productTodisplay = 0;
  var filterResults = false;
  var startDate = "Select Start date";
  var endDate = "Select End date";
  var finalStartDate;
  var finalEndDate;

  var transactionTypes = ["Sales", "Purchases", "All transactions"];
  List<String> productsDropDown = [];
  var selectedProduct;

  _TransactionsPageState(this.transactionsToDisplay);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#086ad8"),
        title: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: HexColor("#086ad8"),
            ),
            child: new DropdownButton<String>(
              autofocus: false,
              isExpanded: true,
              icon: Icon(
                Icons.arrow_downward,
                color: Colors.white,
              ),
              underline: DropdownButtonHideUnderline(
                child: new Container(),
              ),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20),
              items: transactionTypes.map((String dropitem) {
                return DropdownMenuItem<String>(
                    value: dropitem,
                    child: Text(
                      dropitem,
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                      ),
                    ));
              }).toList(),
              onChanged: (String newitem) {
                for (var i = 0; i < transactionTypes.length; i++) {
                  if (transactionTypes[i] == newitem) {
                    setState(() {
                      transactionsToDisplay = i;
                    });
                  }
                }
              },
              value: transactionTypes[transactionsToDisplay],
            )),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: RaisedButton(
                child: Text("Filter Results"),
                onPressed: () {
                  if (filterResults == false) {
                    setState(() {
                      filterResults = true;
                    });
                  } else {
                    setState(() {
                      filterResults = false;
                      // startDate = "Select Start date";
                      // endDate = "Select End date";
                      // finalStartDate = null;
                      // finalEndDate = null;
                    });
                  }
                }),
          ),
          filterResults == true
              ? Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: HexColor("#086ad8"),
                  ),
                  // width: ,
                  child: DropdownButton<String>(
                    dropdownColor: HexColor("#086ad8"),
                    autofocus: false,
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    underline: DropdownButtonHideUnderline(
                      child: new Container(),
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                    hint: Text(
                      "Select a product",
                      style: TextStyle(
                          fontFamily: 'WorkSans',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                    items: productsDropDown.map((String dropitem) {
                      return DropdownMenuItem<String>(
                          value: dropitem,
                          child: Text(
                            dropitem,
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                            ),
                          ));
                    }).toList(),
                    onChanged: (String newitem) {
                      for (var i = 0; i < productsDropDown.length; i++) {
                        if (newitem == productsDropDown[i]) {
                          if (productsDropDown[i] == "Show all products") {
                            productTodisplay = i;
                            selectedProduct = null;
                          } else {
                            productTodisplay = i;
                            selectedProduct = productsDropDown[i];
                          }

                          setState(() {});
                        }
                      }
                      if (this.mounted) {
                        // setState(() {
                        //   this.productSelected = newitem;
                        // });
                      }
                    },
                    value: productsDropDown[productTodisplay],
                  ),
                )
              : Container(),
          filterResults == true
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                      width: double.infinity,
                      //color: Colors.greenAccent,
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Select Custom date Range",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(2021, 1, 1),
                                  onChanged: (date) {}, onConfirm: (date) {
                                setState(() {
                                  int year = date.year;
                                  int month = date.month;
                                  int day = date.day;
                                  startDate =
                                      "$year" + "/" + "$month" + "/" + "$day";

                                  finalStartDate = date;
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: Text(
                              '$startDate',
                              style: TextStyle(color: Colors.blue),
                            )),
                        TextButton(
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(2021, 1, 1),
                                  onChanged: (date) {}, onConfirm: (date) {
                                setState(() {
                                  int year = date.year;
                                  int month = date.month;
                                  int day = date.day;
                                  endDate =
                                      "$year" + "/" + "$month" + "/" + "$day";
                                  date = new DateTime(
                                      year, month, day, 23, 59, 59);
                                  finalEndDate = date;
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: Text(
                              '$endDate',
                              style: TextStyle(color: Colors.blue),
                            )),
                        RaisedButton(
                          onPressed: () {
                            startDate = "Select Start date";
                            endDate = "Select End date";
                            finalStartDate = null;
                            finalEndDate = null;
                            setState(() {});
                          },
                          child: Text("Reset"),
                        )
                      ],
                    ),
                  ],
                )
              : Container(),
          Divider(
            color: Colors.black,
            thickness: 3,
          ),
          transactionTypes[transactionsToDisplay] == "Sales"
              ? StreamBuilder(
                  stream: firebaseFirestore
                      .collection("sales")
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    productsDropDown = ["Show all products"];
                    clearListsForPdf();
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      QuerySnapshot snap = snapshot.data;
                      List<Widget> containers = [];
                      for (var item in snap.docs) {
                        SalesModel salesModel = SalesModel.fromFireBase(item);
                        if (productsDropDown.contains(salesModel.productName)) {
                        } else {
                          productsDropDown
                              .add(salesModel.productName.toString());
                        }
                      }

                      if (selectedProduct == null) {
                        for (var item in snap.docs) {
                          SalesModel salesModel = SalesModel.fromFireBase(item);

                          DateTime saleDateTime = salesModel.date.toDate();
                          try {
                            if (saleDateTime.isBefore(finalEndDate) &&
                                saleDateTime.isAfter(finalStartDate)) {
                              containers.add(addSalesToWidgetList(salesModel));
                              addToProductListsForPdf(salesModel, null, null);
                            }
                          } catch (e) {
                            containers.add(addSalesToWidgetList(salesModel));
                            addToProductListsForPdf(salesModel, null, null);
                          }
                        }
                      } else {
                        for (var item in snap.docs) {
                          SalesModel salesModel = SalesModel.fromFireBase(item);
                          if (salesModel.productName
                              .toString()
                              .toLowerCase()
                              .contains(
                                  selectedProduct.toString().toLowerCase())) {
                            DateTime saleDateTime = salesModel.date.toDate();
                            try {
                              if (saleDateTime.isBefore(finalEndDate) &&
                                  saleDateTime.isAfter(finalStartDate)) {
                                containers
                                    .add(addSalesToWidgetList(salesModel));
                                addToProductListsForPdf(salesModel, null, null);
                              }
                            } catch (e) {
                              containers.add(addSalesToWidgetList(salesModel));
                              addToProductListsForPdf(salesModel, null, null);
                            }
                          }
                        }
                      }

                      return Expanded(
                        child: ListView(
                          children: containers,
                        ),
                      );
                    }
                  })
              : Container(),
          transactionTypes[transactionsToDisplay] == "Purchases"
              ? StreamBuilder(
                  stream: firebaseFirestore
                      .collection("purchases")
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    productsDropDown = ["Show all products"];
                    clearListsForPdf();
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      QuerySnapshot snap = snapshot.data;
                      List<Widget> containers = [];
                      for (var item in snap.docs) {
                        PurchasesModel purchasesModel =
                            PurchasesModel.fromFireBase(item);
                        if (productsDropDown
                            .contains(purchasesModel.productName)) {
                        } else {
                          productsDropDown
                              .add(purchasesModel.productName.toString());
                        }
                      }

                      if (selectedProduct == null) {
                        for (var item in snap.docs) {
                          PurchasesModel purchasesModel =
                              PurchasesModel.fromFireBase(item);

                          DateTime saleDateTime = purchasesModel.date.toDate();
                          try {
                            if (saleDateTime.isBefore(finalEndDate) &&
                                saleDateTime.isAfter(finalStartDate)) {
                              containers.add(
                                  addPurchasesToWidgetList(purchasesModel));
                              addToProductListsForPdf(
                                  null, purchasesModel, null);
                            }
                          } catch (e) {
                            containers
                                .add(addPurchasesToWidgetList(purchasesModel));
                            addToProductListsForPdf(null, purchasesModel, null);
                          }
                        }
                      } else {
                        for (var item in snap.docs) {
                          PurchasesModel purchasesModel =
                              PurchasesModel.fromFireBase(item);
                          if (purchasesModel.productName
                              .toString()
                              .toLowerCase()
                              .contains(
                                  selectedProduct.toString().toLowerCase())) {
                            DateTime purchaseDateTime =
                                purchasesModel.date.toDate();
                            try {
                              if (purchaseDateTime.isBefore(finalEndDate) &&
                                  purchaseDateTime.isAfter(finalStartDate)) {
                                containers.add(
                                    addPurchasesToWidgetList(purchasesModel));
                                addToProductListsForPdf(
                                    null, purchasesModel, null);
                              }
                            } catch (e) {
                              containers.add(
                                  addPurchasesToWidgetList(purchasesModel));
                              addToProductListsForPdf(
                                  null, purchasesModel, null);
                            }
                          }
                        }
                      }

                      return Expanded(
                        child: ListView(
                          children: containers,
                        ),
                      );
                    }
                  })
              : Container(),
          transactionTypes[transactionsToDisplay] == "All transactions"
              ? StreamBuilder(
                  stream: firebaseFirestore
                      .collection("all_transactions")
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    productsDropDown = ["Show all products"];
                    clearListsForPdf();
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      QuerySnapshot snap = snapshot.data;
                      List<Widget> containers = [];
                      for (var item in snap.docs) {
                        AllTransactionsModel allTransactionsModel =
                            AllTransactionsModel.fromFireBase(item);
                        if (productsDropDown
                            .contains(allTransactionsModel.productName)) {
                        } else {
                          productsDropDown
                              .add(allTransactionsModel.productName.toString());
                        }
                      }

                      if (selectedProduct == null) {
                        for (var item in snap.docs) {
                          AllTransactionsModel allTransactionsModel =
                              AllTransactionsModel.fromFireBase(item);

                          DateTime saleDateTime =
                              allTransactionsModel.date.toDate();
                          try {
                            if (saleDateTime.isBefore(finalEndDate) &&
                                saleDateTime.isAfter(finalStartDate)) {
                              containers.add(addAllTransactionsToWidget(
                                  allTransactionsModel));
                              addToProductListsForPdf(
                                  null, null, allTransactionsModel);
                            }
                          } catch (e) {
                            containers.add(addAllTransactionsToWidget(
                                allTransactionsModel));
                            addToProductListsForPdf(
                                null, null, allTransactionsModel);
                          }
                        }
                      } else {
                        for (var item in snap.docs) {
                          AllTransactionsModel allTransactionsModel =
                              AllTransactionsModel.fromFireBase(item);
                          if (allTransactionsModel.productName
                              .toString()
                              .toLowerCase()
                              .contains(
                                  selectedProduct.toString().toLowerCase())) {
                            DateTime saleDateTime =
                                allTransactionsModel.date.toDate();
                            try {
                              if (saleDateTime.isBefore(finalEndDate) &&
                                  saleDateTime.isAfter(finalStartDate)) {
                                containers.add(addAllTransactionsToWidget(
                                    allTransactionsModel));
                                addToProductListsForPdf(
                                    null, null, allTransactionsModel);
                              }
                            } catch (e) {
                              containers.add(addAllTransactionsToWidget(
                                  allTransactionsModel));
                              addToProductListsForPdf(
                                  null, null, allTransactionsModel);
                            }
                          }
                        }
                      }

                      return Expanded(
                        child: ListView(
                          children: containers,
                        ),
                      );
                    }
                  })
              : Container()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Center(
            child: Text(
          "View PDF",
          textAlign: TextAlign.center,
        )),
        onPressed: () {
          _createPDF();
        },
      ),
    );
  }

  clearListsForPdf() {
    productIdList = [];
    productNameList = [];
    costPriceList = [];
    sellingPriceList = [];
    quantityList = [];
    moneyReceivedList = [];
    moneySpentList = [];
    dateList = [];
  }

  addToProductListsForPdf(
      [SalesModel salesModel,
      PurchasesModel purchasesModel,
      AllTransactionsModel allTransactionsModel]) {
    if (salesModel == null && purchasesModel == null) {
      productIdList.add(allTransactionsModel.productId);
      productNameList.add(allTransactionsModel.productName);
      costPriceList.add(allTransactionsModel.costPrice);
      sellingPriceList.add(allTransactionsModel.sellingPrice);
      quantityList.add(allTransactionsModel.amount);
      moneyReceivedList.add(allTransactionsModel.moneyReceived);
      moneySpentList.add(allTransactionsModel.moneySpent);
      dateList.add(allTransactionsModel.date.toDate());
    } else if (salesModel == null && allTransactionsModel == null) {
      productIdList.add(purchasesModel.productId);
      productNameList.add(purchasesModel.productName);
      costPriceList.add(purchasesModel.costPrice);
      sellingPriceList.add(0);
      quantityList.add(purchasesModel.amount);
      moneyReceivedList.add(0);
      moneySpentList.add(purchasesModel.moneySpent);
      dateList.add(purchasesModel.date.toDate());
    } else {
      productIdList.add(salesModel.productId);
      productNameList.add(salesModel.productName);
      costPriceList.add(salesModel.costPrice);
      sellingPriceList.add(salesModel.sellingPrice);
      quantityList.add(salesModel.amount);
      moneyReceivedList.add(salesModel.moneyReceived);
      moneySpentList.add(0);
      dateList.add(salesModel.date.toDate());
    }
  }

  addSalesToWidgetList(SalesModel salesModel) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5))),
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            salesModel.productName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Product ID - " + salesModel.productId.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Old Stock - " + salesModel.previousStock.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Pieces Sold - " + salesModel.amount.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Stock Balance - " + formatNumber(salesModel.newStock.toString()),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Cost price - " + formatNumber(salesModel.costPrice.toString()),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Selling price - " +
                formatNumber(salesModel.sellingPrice.toString()),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Date - " + salesModel.date.toDate().toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Money Received: ₦" +
                  formatNumber(salesModel.moneyReceived.toString()),
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          )
        ],
      )),
    );
  }

  addPurchasesToWidgetList(PurchasesModel purchasesModel) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5))),
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Product Name - " + purchasesModel.productName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Product ID - " + purchasesModel.productId.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Old Stock - " +
                formatNumber(purchasesModel.previousStock.toString()),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Pieces Bought - " + purchasesModel.amount.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Stock Balance - " +
                formatNumber(purchasesModel.newStock.toString()),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Cost price - " + formatNumber(purchasesModel.costPrice.toString()),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Date - " + purchasesModel.date.toDate().toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Money Spent: ₦" +
                  formatNumber(purchasesModel.moneySpent.toString()),
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          )
        ],
      )),
    );
  }

  addAllTransactionsToWidget(AllTransactionsModel allTransactionsModel) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5))),
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Product Name - " + allTransactionsModel.productName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Product ID - " + allTransactionsModel.productId.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Old Stock - " +
                formatNumber(allTransactionsModel.previousStock.toString()),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Pieces Bought - " + allTransactionsModel.amount.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Stock Balance - " +
                formatNumber(allTransactionsModel.newStock.toString()),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            "Cost price - " +
                formatNumber(allTransactionsModel.costPrice.toString()),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          allTransactionsModel.sellingPrice == null
              ? Container()
              : Text(
                  "Selling Price - " +
                      formatNumber(
                          allTransactionsModel.sellingPrice.toString()),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
          Text(
            "Date - " + allTransactionsModel.date.toDate().toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          allTransactionsModel.sellingPrice == null
              ? Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Money Spent: ₦" +
                        formatNumber(
                            allTransactionsModel.moneySpent.toString()),
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                )
              : Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Money Received: ₦" +
                        formatNumber(
                            allTransactionsModel.moneyReceived.toString()),
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                )
        ],
      )),
    );
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();
    final Size pageSize = page.getClientSize();

    final PdfGrid grid = getGrid();

    grid.style = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 17,
            style: PdfFontStyle.bold));

    final PdfLayoutResult result = drawHeader(page, pageSize, grid);
    getGrid();
    drawGrid(page, grid, result);

    List<int> bytes = document.save();
    document.dispose();

    saveandLaunchFile(bytes, 'Output.pdf');
  }

  PdfGrid getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 8);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Id';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Product Name';
    headerRow.cells[2].value = 'Cost Price';
    headerRow.cells[3].value = 'Selling Price';
    headerRow.cells[4].value = 'Quantity';
    headerRow.cells[5].value = 'Money Received';
    headerRow.cells[6].value = 'Money Spent';
    // headerRow.cells[7].value = 'Previous Stock';
    // headerRow.cells[8].value = 'New Stock';
    headerRow.cells[7].value = 'Date';
    for (var i = 0; i < productIdList.length; i++) {
      addProducts(
          productIdList[i],
          productNameList[i],
          costPriceList[i],
          sellingPriceList[i],
          quantityList[i],
          moneyReceivedList[i],
          moneySpentList[i],
          dateList[i],
          grid);
    }
    //Add rows
    // addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
    // addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
    // addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
    // addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
    // addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
    // addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
    //Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Set gird columns width
    //grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
    DateTime now = DateTime.now();
    // DateTime  nowDate = new DateTime(now.year,now.month,now.day);
    page.graphics.drawString(
        'Transactions', PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
    page.graphics.drawString(
        'Date: ' +
            now.year.toString() +
            '-' +
            now.month.toString() +
            '-' +
            now.day.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(25, 60, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);

    // const String address = '''Bill To: \r\n\r\nAbraham Swearegin, ''';
    String address = '';
    return PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 100, pageSize.width, pageSize.height - 120));
  }

  void addProducts(productId, productName, costPrice, sellingPrice, quantity,
      moneyReceived, moneySpent, date, PdfGrid grid) {
    // DateTime finalDate = date.toDate;
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId.toString();
    row.cells[1].value = productName;
    row.cells[2].value = formatNumber(costPrice.toString());
    sellingPrice == null
        ? row.cells[3].value = '0'
        : row.cells[3].value = formatNumber(sellingPrice.toString());
    row.cells[4].value = formatNumber(quantity.toString());
    moneyReceived == null
        ? row.cells[5].value = '0'
        : row.cells[5].value = formatNumber(moneyReceived.toString());
    moneySpent == null
        ? row.cells[6].value = '0'
        : row.cells[6].value = formatNumber(moneySpent.toString());
    row.cells[7].value = date.year.toString() +
        '-' +
        date.month.toString() +
        '-' +
        date.day.toString();
  }

  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect totalPriceCellBounds;
    Rect quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0));

    //Draw grand total.
    // page.graphics.drawString('Grand Total',
    //     PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
    //     bounds: Rect.fromLTWH(
    //         quantityCellBounds.left,
    //         result.bounds.bottom + 10,
    //         quantityCellBounds.width,
    //         quantityCellBounds.height));
    // page.graphics.drawString("ffsdsfdfsd",
    //     PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
    //     bounds: Rect.fromLTWH(
    //         totalPriceCellBounds.left,
    //         result.bounds.bottom + 10,
    //         totalPriceCellBounds.width,
    //         totalPriceCellBounds.height));
  }

  // String convertDateTimeDisplay(String date) {
  //   final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  //   final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
  //   final DateTime displayDate = displayFormater.parse(date);
  //   final String formatted = serverFormater.format(displayDate);
  //   return formatted;
  // }
}
