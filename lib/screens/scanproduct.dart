import 'dart:io';

import 'package:cipa_gifts/firebase/firebasemethods.dart';
import 'package:cipa_gifts/screens/productscreen.dart';
import 'package:flashlight/flashlight.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanProductPage extends StatefulWidget {
  @override
  _ScanProductPageState createState() => _ScanProductPageState();
}

class _ScanProductPageState extends State<ScanProductPage> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var modalState = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }
  // // initFlashlight() async {
  // //   bool hasFlash = await Flashlight.hasFlashlight;
  // //   print("Device has flash ? $hasFlash");
  // //   setState(() {
  // //     _hasFlashlight = hasFlash;
  // //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: modalState,
        child: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
            Expanded(
              flex: 2,
              // child: FittedBox(
              //   fit: BoxFit.contain,
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Column(
                      children: [
                        Text(
                          //Barcode Type: ${describeEnum(result.format)}
                          ' QR Code Data: ${result.code}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        RaisedButton(
                          onPressed: () {
                            setState(() {
                              modalState = true;
                            });
                            checking();
                          },
                          child: Text("Search for Product"),
                        )
                      ],
                    )
                  else
                    Text(
                      'Scan a code',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(
                            top: 30,
                            bottom: 30,
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    await controller?.pauseCamera();
                                  },
                                  child: Image.asset(
                                    "assets/images/pause.png",
                                    width: 70,
                                  )),
                              Text("Pause Scan")
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(
                            top: 30,
                            bottom: 30,
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    await controller?.resumeCamera();
                                  },
                                  child: Image.asset(
                                    "assets/images/play.png",
                                    width: 70,
                                  )),
                              Text("Resume Scan")
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(
                            top: 30,
                            bottom: 30,
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    await controller?.toggleFlash();
                                    setState(() {});
                                  },
                                  child: Image.asset(
                                    "assets/images/torch.png",
                                    width: 70,
                                  )),
                              Text("On/Off torch")
                            ],
                          )),
                    ],
                  ),
                ],
                // ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  checking() async {
     var code = result.code;
    result = null;
    // print(result.code);
    // print("uiguiguiguigugiuguiguiguuiguigu");
    await checkIfProductExists2(code).then((value) {
      // print(value);
      if (value == true) {
        setState(() {
          modalState = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductScreen(int.parse(code))));
                 
      } else {
        setState(() {
          modalState = false;
        });
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Product not found"),
                content: Text("Product not found for QR Code - " + code),
              );
            });
            
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
