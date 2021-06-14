import 'package:cipa_gifts/firebase/firebasemethods.dart';
import 'package:cipa_gifts/screens/authentication.dart';
import 'package:cipa_gifts/screens/login.dart';
import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    method();
    initializeApp();
  }

  void method() async {
    await Future.delayed(Duration(seconds: 3), _navi);
  }

  Future<void> _navi() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Image(
            image: AssetImage("assets/images/xitalogo.png"),
            // height: 200,
            //width: double.infinity,
          ),
        ),
      ),
    );
  }
}
