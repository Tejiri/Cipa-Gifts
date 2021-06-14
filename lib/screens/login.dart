import 'package:cipa_gifts/firebase/firebasemethods.dart';
import 'package:cipa_gifts/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool modalState = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: modalState,
      child: Scaffold(
          body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            child: ListView(
              shrinkWrap: true,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Padding(padding: EdgeInsets.only(top: 150)),
                Text(
                  "Cipa Gift Stocks",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: HexColor("#086ad8"),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Padding(padding: EdgeInsets.only(bottom: 25)),
                Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20)),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: username,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Username"),
                    )),
                Padding(padding: EdgeInsets.only(top: 15)),
                Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20)),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Password"),
                    )),
                Padding(padding: EdgeInsets.only(top: 30)),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        modalState = true;
                      });
                      await signUserIn(username.text, password.text)
                          .then((value) {
                        if (value == true) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("Error"),
                                    content: Text(value.toString()),
                                  ));
                        }

                        //print(value);
                        setState(() {
                          modalState = false;
                        });
                      });
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 30, right: 30),
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      decoration: BoxDecoration(
                          color: HexColor("#086ad8"),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          "Forgot Password?",
                          textAlign: TextAlign.center,
                        )),
                    Text(
                      "Recover",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: HexColor("#086ad8")),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
