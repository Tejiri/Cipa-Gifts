import 'package:cipa_gifts/screens/addproduct.dart';
import 'package:cipa_gifts/screens/authentication.dart';
import 'package:cipa_gifts/screens/charts.dart';
import 'package:cipa_gifts/screens/login.dart';
import 'package:cipa_gifts/screens/report.dart';
import 'package:cipa_gifts/screens/scanproduct.dart';
import 'package:cipa_gifts/screens/searchproduct.dart';
import 'package:cipa_gifts/screens/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../firebase/firebasemethods.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // /backgroundColor: Colors.black,
      appBar: AppBar(
        //toolbarHeight: 80,
        //leading: Image.asset("assets/images/xitalogo.png"),
        centerTitle: true,
        title: Text(
          "Welcome to Cipa Gifts Stock Management System",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: HexColor("#086ad8")
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Container(
              height: double.infinity,
              width: double.infinity,
              //color: Colors.black.withOpacity(0.5),
              child: Image.asset(
                "assets/images/xitalogo-removebg.png",
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.05),
              )),
          ListView(
            children: [
              Padding(padding: EdgeInsets.only(top: 40)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  homewidgets(
                      "assets/images/addproduct.png",
                      "Add product",
                      "assets/images/scan.png",
                      "Scan product",
                      "assets/images/settings.png",
                      "Settings"),
                  homewidgets(
                      "assets/images/search.png",
                      "Search",
                      "assets/images/report.png",
                      "Report",
                      "assets/images/logout.png",
                      "Logout")

                  //CircleAvatar(child: Icon(Icons.access_alarm,color: Colors.black,size: 50,),radius: 60,backgroundColor: Colors.white,),
                ],
              ),

              // Center(
              //   child: QrImage(
              //     data: "1234567890",
              //     version: QrVersions.auto,
              //     backgroundColor: Colors.amber,
              //     //size: 800.0,
              //   ),
              // ),
            ],
          )
        ],
      )),
    );
  }

  Widget homewidgets(image1, title1, image2, title2, image3, title3) {
    return Column(
      children: [
        GestureDetector(
          child: CircleAvatar(
              radius: 35,
              child: Image.asset(
                "$image1",
              )),
          onTap: () {
            if (image1 == "assets/images/addproduct.png") {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddProductPage()));
            } else if (image1 == "assets/images/search.png") {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SearchProductPage()));
            }
          },
        ),
        Text(
          "$title1",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        Padding(padding: EdgeInsets.only(top: 40)),
        GestureDetector(
          child: CircleAvatar(
              radius: 35,
              child: Image.asset(
                "$image2",
              )),
          onTap: () {
            if (image2 == "assets/images/scan.png") {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ScanProductPage()));
            } else {
               Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ReportPage()));
            }
          },
        ),
        Text(
          "$title2",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        Padding(padding: EdgeInsets.only(top: 40)),
        GestureDetector(
          child: CircleAvatar(
              radius: 35,
              child: Image.asset(
                "$image3",
              )),
          onTap: () {
            if (image3 == "assets/images/settings.png") {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            }
          },
        ),
        Text(
          "$title3",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        )
      ],
    );
  }
}
