import 'dart:io';

import 'package:cipa_gifts/firebase/firebasemethods.dart';
import 'package:cipa_gifts/helpers/imagehelpers.dart';
import 'package:cipa_gifts/helpers/random.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sweetalert/sweetalert.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController stockQuantityController = TextEditingController();
  bool modalState = false;
  File _image;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        backgroundColor: HexColor("#086ad8"),
        title: Text('Publish Product'),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: modalState,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              imageContainer(),
              Padding(padding: EdgeInsets.only(top: 20)),
              showTextField(productNameController, TextInputType.text,
                  "Enter product name", "Product name"),
              Padding(padding: EdgeInsets.only(top: 20)),
              showTextField(productPriceController, TextInputType.number,
                  "Enter product price", "Product price"),
              Padding(padding: EdgeInsets.only(top: 20)),
              showTextField(stockQuantityController, TextInputType.number,
                  "Enter stock quantity", "Stock Quantity"),
              Padding(padding: EdgeInsets.only(top: 20)),
              Container(
                
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.3)),
                margin: EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(

                  child: Text("Publish Product",style: TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                    primary: HexColor("#086ad8"),
                      minimumSize: Size.fromHeight(50)),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        modalState = true;
                      });
                      checkForInternet().then((value) {
                        if (value) {
                          if (_image == null) {
                            setState(() {
                              modalState = false;
                            });
                            SweetAlert.show(context,
                                title: "Publishing failed",
                                subtitle: "No image selected",
                                style: SweetAlertStyle.error);
                          } else {
                            checkIfProductExists(productNameController.text)
                                .then((value) async {
                              if (value) {
                                setState(() {
                                  modalState = false;
                                });
                                SweetAlert.show(context,
                                    title: "Failed to upload",
                                    subtitle: "Product already exists",
                                    style: SweetAlertStyle.error);
                              } else {
                                await addProduct(
                                        productNameController.text,
                                        int.parse(productPriceController.text),
                                        int.parse(stockQuantityController.text),
                                        _image)
                                    .then((value) {
                                  if (value) {
                                    setState(() {
                                      modalState = false;
                                    });
                                    SweetAlert.show(context,
                                        title: "Success",
                                        subtitle:
                                            "Product uploaded successfully",
                                        style: SweetAlertStyle.success);
                                  } else if (value == false) {
                                    setState(() {
                                      modalState = false;
                                    });
                                    SweetAlert.show(context,
                                        title: "Failed",
                                        subtitle:
                                            "Product not uploaded, something went wrong",
                                        style: SweetAlertStyle.error);
                                  }
                                });
                              }
                            });
                          }
                        } else {
                          setState(() {
                            modalState = false;
                          });
                          SweetAlert.show(context,
                              title: "No internet",
                              subtitle:
                                  "Internet connection required to upload product",
                              style: SweetAlertStyle.error);
                        }
                      });
                    }
                  },
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 100)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: HexColor('#086ad8'),
        onPressed: () async {
          await getImage().then((value) {
            setState(() {
              _image = value;
            });
          });
        },
        label: Text("Pick Image",style: TextStyle(color: Colors.black),),
        icon: Icon(Icons.add_a_photo,color: Colors.black,),
      ),
    );
  }

  imageContainer() {
    return Container(
        height: 250,
        decoration: BoxDecoration(
            color: Colors.white, border: Border(bottom: BorderSide(width: 3))),
        child: Center(
          child: _image == null
              ? Text(
                  'No image selected.',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )
              : Image.file(
                  _image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
        ));
  }

  showDialogMessage(title, message) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(message),
            ));
  }

  showTextField(TextEditingController controller, TextInputType textInputType,
      String hintText, String labelText) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      margin: EdgeInsets.only(left: 20, right: 20),
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
          prefix: controller == productPriceController ? Text("₦") : Text(""),
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
      ),
    );
  }
}
