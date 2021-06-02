import 'package:cipa_gifts/firebase/firebasemethods.dart';
import 'package:cipa_gifts/helpers/random.dart';
import 'package:cipa_gifts/models/alltransactionsmodel.dart';
import 'package:cipa_gifts/models/productmodel.dart';
import 'package:cipa_gifts/models/salesmodel.dart';
import 'package:cipa_gifts/screens/transactions.dart';
import 'package:cipa_gifts/screens/searchproduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  ProductModel productModel1;
  ProductModel productModel2;
  int totalSalesForJanuary = 0;
  int totalSalesForFebruary = 0;
  int totalSalesForMarch = 0;
  int totalSalesForApril = 0;
  int totalSalesForMay = 0;
  int totalSalesForJune = 0;
  int totalSalesForJuly = 0;
  int totalSalesForAugust = 0;
  int totalSalesForSeptember = 0;
  int totalSalesForOctober = 0;
  int totalSalesForNovember = 0;
  int totalSalesForDecember = 0;
  int totalIncomeforCurrentYear = 0;
  int totalExpenditureforCurrentYear = 0;
  var cutOffYValue = 5.0;
  var dateTextStyle =
      TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "Reports",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.bar_chart),
                  padding: EdgeInsets.only(right: 10),
                  color: Colors.black,
                  onPressed: () {
                    displayBottomSheetGraph();
                  },
                )
              ],
              backgroundColor: Colors.white,
              pinned: true,
              snap: false,
              floating: true,
              expandedHeight: 330.0,
              flexibleSpace: StreamBuilder(
                  stream: firebaseFirestore
                      .collection('all_transactions')
                      .snapshots(),
                  builder: (context, snapshot) {
                    totalSalesForJanuary = 0;
                    totalSalesForFebruary = 0;
                    totalSalesForMarch = 0;
                    totalSalesForApril = 0;
                    totalSalesForMay = 0;
                    totalSalesForJune = 0;
                    totalSalesForJuly = 0;
                    totalSalesForAugust = 0;
                    totalSalesForSeptember = 0;
                    totalSalesForOctober = 0;
                    totalSalesForNovember = 0;
                    totalSalesForDecember = 0;

                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      totalIncomeforCurrentYear = 0;
                      totalExpenditureforCurrentYear = 0;
                      QuerySnapshot querySnapshot = snapshot.data;
                      for (var item in querySnapshot.docs) {
                        AllTransactionsModel allTransactionsModel =
                            AllTransactionsModel.fromFireBase(item);
                        DateTime date = allTransactionsModel.date.toDate();
                        if (date.year == DateTime.now().year) {
                          if (allTransactionsModel.moneyReceived == null) {
                            totalExpenditureforCurrentYear =
                                totalExpenditureforCurrentYear +
                                    allTransactionsModel.moneySpent;
                          } else {
                            totalIncomeforCurrentYear =
                                totalIncomeforCurrentYear +
                                    allTransactionsModel.moneyReceived;

                            switch (date.month) {
                              case 1:
                                totalSalesForJanuary = totalSalesForJanuary +
                                    (allTransactionsModel.amount *
                                        allTransactionsModel.sellingPrice);
                                break;
                              case 2:
                                totalSalesForFebruary = totalSalesForFebruary +
                                    (allTransactionsModel.amount *
                                        allTransactionsModel.sellingPrice);
                                break;
                              case 3:
                                totalSalesForMarch = totalSalesForMarch +
                                    (allTransactionsModel.amount *
                                        allTransactionsModel.sellingPrice);
                                break;
                              case 4:
                                totalSalesForApril = totalSalesForApril +
                                    (allTransactionsModel.amount *
                                        allTransactionsModel.sellingPrice);
                                break;
                              case 5:
                                totalSalesForMay = totalSalesForMay +
                                    (allTransactionsModel.amount *
                                        allTransactionsModel.sellingPrice);
                                break;
                              case 6:
                                totalSalesForJune = totalSalesForJune +
                                    (allTransactionsModel.amount *
                                        allTransactionsModel.sellingPrice);
                                break;
                              case 7:
                                totalSalesForJuly = totalSalesForJuly +
                                    (allTransactionsModel.amount *
                                        allTransactionsModel.sellingPrice);
                                break;
                              case 8:
                                totalSalesForAugust = totalSalesForAugust +
                                    (allTransactionsModel.amount *
                                        allTransactionsModel.sellingPrice);
                                break;
                              case 9:
                                totalSalesForSeptember =
                                    totalSalesForSeptember +
                                        (allTransactionsModel.amount *
                                            allTransactionsModel.sellingPrice);
                                break;
                              case 10:
                                totalSalesForOctober = totalSalesForOctober +
                                    (allTransactionsModel.amount *
                                        allTransactionsModel.sellingPrice);
                                break;
                              case 11:
                                totalSalesForNovember = totalSalesForNovember +
                                    (allTransactionsModel.amount *
                                        allTransactionsModel.sellingPrice);
                                break;
                              case 12:
                                totalSalesForDecember = totalSalesForDecember +
                                    (allTransactionsModel.amount *
                                        allTransactionsModel.sellingPrice);
                                break;
                              default:
                            }
                          }
                        }
                      }
                      return SafeArea(
                        child: FlexibleSpaceBar(
                            // titlePadding: EdgeInsets.all(0),
                            // title: Text('Cipa Gift Stock Management System'),

                            background: ListView(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 60)),
                            Text(
                              "Sales for " + DateTime.now().year.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              // width: 300,
                              height: 140,
                              margin:
                                  EdgeInsets.only(left: 5, right: 10, top: 30),
                              child: LineChart(
                                LineChartData(
                                  lineTouchData: LineTouchData(enabled: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: [
                                        FlSpot(
                                            0, totalSalesForJanuary.toDouble()),
                                        FlSpot(1,
                                            totalSalesForFebruary.toDouble()),
                                        FlSpot(
                                            2, totalSalesForMarch.toDouble()),
                                        FlSpot(
                                            3, totalSalesForApril.toDouble()),
                                        FlSpot(4, totalSalesForMay.toDouble()),
                                        FlSpot(5, totalSalesForJune.toDouble()),
                                        FlSpot(6, totalSalesForJuly.toDouble()),
                                        FlSpot(
                                            7, totalSalesForAugust.toDouble()),
                                        FlSpot(8,
                                            totalSalesForSeptember.toDouble()),
                                        FlSpot(
                                            9, totalSalesForOctober.toDouble()),
                                        FlSpot(10,
                                            totalSalesForNovember.toDouble()),
                                        FlSpot(11,
                                            totalSalesForDecember.toDouble()),
                                      ],
                                      isCurved: false,
                                      barWidth: 8,
                                      colors: [
                                        Colors.black,
                                      ],
                                      belowBarData: BarAreaData(
                                        show: true,
                                        colors: [
                                          Color.fromRGBO(0, 29, 76, 0.6),
                                        ],
                                        cutOffY: cutOffYValue,
                                        applyCutOffY: true,
                                      ),
                                      aboveBarData: BarAreaData(
                                        show: true,
                                        colors: [
                                          Colors.orange.withOpacity(0.6)
                                        ],
                                        cutOffY: cutOffYValue,
                                        applyCutOffY: true,
                                      ),
                                      dotData: FlDotData(
                                        show: false,
                                      ),
                                    ),
                                  ],
                                  minY: 0,
                                  titlesData: FlTitlesData(
                                    bottomTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 14,
                                        getTextStyles: (value) => dateTextStyle,
                                        getTitles: (value) {
                                          switch (value.toInt()) {
                                            case 0:
                                              return 'Jan';
                                            case 1:
                                              return 'Feb';
                                            case 2:
                                              return 'Mar';
                                            case 3:
                                              return 'Apr';
                                            case 4:
                                              return 'May';
                                            case 5:
                                              return 'Jun';
                                            case 6:
                                              return 'Jul';
                                            case 7:
                                              return 'Aug';
                                            case 8:
                                              return 'Sep';
                                            case 9:
                                              return 'Oct';
                                            case 10:
                                              return 'Nov';
                                            case 11:
                                              return 'Dec';
                                            default:
                                              return '';
                                          }
                                        }),
                                    leftTitles: SideTitles(
                                      showTitles: true,
                                      getTitles: (value) {
                                        //\₦
                                        return '$value';
                                      },
                                    ),
                                  ),
                                  axisTitleData: FlAxisTitleData(
                                      leftTitle:
                                          AxisTitle(showTitle: true, margin: 3,textStyle: dateTextStyle,),
                                      bottomTitle: AxisTitle(
                                        showTitle: true,
                                        margin: 0,
                                        titleText:
                                            DateTime.now().year.toString(),
                                        textStyle: dateTextStyle,
                                      )),
                                  // gridData: FlGridData(
                                  //   show: true,
                                  //   checkToShowHorizontalLine: (double value) {
                                  //     return value == 1 || value == 6 || value == 4 || value == 5;
                                  //   },
                                  // ),
                                ),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Total Income for " +
                                      DateTime.now().year.toString() +
                                      ": ₦${formatNumber(totalIncomeforCurrentYear.toString())}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )),
                            Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  "Total Expenditure for " +
                                      DateTime.now().year.toString() +
                                      ": ₦${formatNumber(totalExpenditureforCurrentYear.toString())}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ))
                          ],
                        )

                            // Container(
                            //   width: double.infinity,
                            //   child: Image.asset('assets/images/xitalogo-removebg.png',fit: BoxFit.fill,),
                            // )
                            ),
                      );
                    }
                  })),
          // const SliverToBoxAdapter(
          //   child: SizedBox(
          //     height: 20,
          //     child: Center(
          //       child: Text('Scroll to see the SliverAppBar in effect.'),
          //     ),
          //   ),
          // ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                    height: 1000,
                    child: Column(
                      children: [
                        // Divider(
                        //   color: Colors.black,
                        //   thickness: 2,
                        // ),
                        StreamBuilder(
                            stream: firebaseFirestore
                                .collection('products')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                QuerySnapshot data = snapshot.data;

                                var noOfProducts = data.size;

                                return generalInfoContainer(
                                    noOfProducts, "Number of Products", 3);
                              }
                            }),
                        //nuhihihihiohiohiohihiohiohiohiohiooiihhio
                        StreamBuilder(
                            stream: firebaseFirestore
                                .collection('sales')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                QuerySnapshot data = snapshot.data;
                                var noOfSales = data.size;

                                return generalInfoContainer(
                                    noOfSales, "Number of Sales", 0);
                              }
                            }),

                        StreamBuilder(
                            stream: firebaseFirestore
                                .collection('purchases')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                QuerySnapshot data = snapshot.data;

                                var noOfPurchases = data.size;

                                return generalInfoContainer(
                                    noOfPurchases, "Number of Purchases", 1);
                              }
                            }),

                        StreamBuilder(
                            stream: firebaseFirestore
                                .collection('all_transactions')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                QuerySnapshot data = snapshot.data;

                                var allTransactions = data.size;

                                return generalInfoContainer(
                                    allTransactions, "All Transactions", 2);
                              }
                            }),

                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 30),
                          child: Text(
                            "Top selling products",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          //color: Colors.blue,
                          width: double.infinity,
                        ),
                        Container(
                          height: 350,
                          child: StreamBuilder(
                            stream: firebaseFirestore
                                .collection('products')
                                .orderBy('pieces_sold', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                List<Widget> widgetList = [];

                                QuerySnapshot data = snapshot.data;
                                for (var item in data.docs) {
                                  productModel2 =
                                      ProductModel.fromFireBase(item);

                                  widgetList.add(Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20),
                                          width: 200,
                                          height: 200,
                                          color: Colors.white.withOpacity(0.8),
                                          child: Image.network(
                                            productModel2.imageUrl,
                                            fit: BoxFit.fill,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes
                                                      : null,
                                                ),
                                              );
                                            },
                                          )),
                                      Container(
                                          width: 200,
                                          margin: EdgeInsets.only(left: 20),
                                          child: Text(
                                            "${productModel2.productName}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          )),
                                      Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Text(
                                              "Pieces Sold - ${formatNumber(productModel2.piecesSold.toString())}"))
                                    ],
                                  ));
                                }

                                return ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: widgetList);
                              }
                            },
                          ),
                        )
                      ],
                    ));
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }

  displayBottomSheetGraph() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StreamBuilder(
            stream: firebaseFirestore
                .collection('products')
                .orderBy('date_published', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                QuerySnapshot data = snapshot.data;
                var lowStockItems = 0;
                var income = 0;
                var expenditure = 0;
                for (var item in data.docs) {
                  productModel1 = ProductModel.fromFireBase(item);
                  if (productModel1.productQuantity < 10) {
                    lowStockItems++;
                  }
                  income = income + productModel1.totalMoneyReceived;
                  expenditure = expenditure + productModel1.totalMoneySpent;
                }
                return Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 60)),
                    Text(
                      "Basic stock summary",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text("Number of Products: " + data.docs.length.toString(),
                        style: TextStyle(fontSize: 18)),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Text(
                        "Highest selling product: " +
                            data.docs.first.get('product_name').toString(),
                        style: TextStyle(fontSize: 18)),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Text("Low stock items: " + lowStockItems.toString(),
                        style: TextStyle(color: Colors.red, fontSize: 18)),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Text("Total income: ₦${formatNumber(income.toString())}",
                        style: TextStyle(color: Colors.green, fontSize: 18)),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Text(
                        "Total Expenditure: ₦${formatNumber(expenditure.toString())}",
                        style: TextStyle(color: Colors.red, fontSize: 18)),
                  ],
                );
              }
            },
          );
        });
  }

  generalInfoContainer(itemNumber, String containerTitle, int toPage) {
    return GestureDetector(
      onTap: () {
        if (toPage == 3) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SearchProductPage()));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TransactionsPage(toPage)));
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 30),
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
        color: HexColor("#086ad8").withOpacity(0.5),
        width: double.infinity,
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            Wrap(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.only(top: 10),
                  child: CircleAvatar(
                    child: Icon(
                      Icons.inventory,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemNumber.toString() + "",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        "$containerTitle",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 14),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
